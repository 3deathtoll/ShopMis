extends RefCounted

class_name LemonScript

enum {
	TK_STRING,
	TK_WORD,
	TK_LITERAL,
	TK_PUNC,
	TK_OP,
	TK_CALL,
}

class Token:
	var type
	var value
	func _init(t, v):
		type = t
		value = v
	func _to_string():
		return str([type, value])

static func needs_parsing(text: String) -> bool:
	return text.find("{")

static func lex_word_or_literal(ret, text: String, start, i):
	if not start < i: return
	var word = text.substr(start, i - start)
	var type = TK_WORD
	if word in [
		"not",
		"and",
		"or",
	]:
		type = TK_PUNC
	elif word == "true":
		type = TK_LITERAL
		word = true
	elif word == "false":
		type = TK_LITERAL
		word = false
	elif word.is_valid_float():
		if word.is_valid_int():
			type = TK_LITERAL
			word = word.to_int()
		else:
			type = TK_LITERAL
			word = word.to_float()
	ret.append(Token.new(
		type,
		word
	))

func lex(text: String) -> Array:
	var ret := []
	var l := text.length()
	if l == 0:
		return ret
	var in_braces := false
	var in_quotes := false
	var start := 0
	var i := 0
	while i < l:
		var c := text[i]
		var cc := text.substr(i, 2)
		if in_braces:
			if in_quotes:
				if c == "\"":
					if start < i: ret.append(Token.new(
						TK_LITERAL,
						text.substr(start, i - start)
					))
					start = i+1
					in_quotes = false
			elif c.strip_edges() == "":
				lex_word_or_literal(ret, text, start, i)
				start = i+1
			elif c == "}":
				lex_word_or_literal(ret, text, start, i)
				start = i+1
				in_braces = false
				ret.append(Token.new(
					TK_PUNC,
					c
				))
			elif c == "\"":
				lex_word_or_literal(ret, text, start, i)
				start = i+1
				in_quotes = true
			elif (cc in [
				"==", "!=", ">=", "<=",
				"+=", "-=", "*=", "/=", "%=",
			]):
				lex_word_or_literal(ret, text, start, i)
				i+=1
				start = i+1
				ret.append(Token.new(
					TK_PUNC,
					cc
				))
			elif (c in ";(),+-*/%<>="):
				lex_word_or_literal(ret, text, start, i)
				start = i+1
				ret.append(Token.new(
					TK_PUNC,
					c
				))
		elif c == "{":
			if start < i: ret.append(Token.new(
				TK_STRING,
				text.substr(start, i - start)
			))
			start = i+1
			in_braces = true
			in_quotes = false
			ret.append(Token.new(
				TK_PUNC,
				c
			))
		i+=1
	if in_braces:
		if start < i: ret.append(Token.new(
			TK_LITERAL,
			text.substr(start, i - start)
		))
	elif in_quotes:
		lex_word_or_literal(ret, text, start, i)
	else:
		if start < i: ret.append(Token.new(
			TK_STRING,
			text.substr(start, i - start)
		))
	return ret


enum {
	P_STR,
	P_IF,
	P_ELIF,
	P_ELSE,
	P_ENDIF,
	P_EXP,
	P_SET,
	P_CTRL
}

class PNode:
	var type
	var value
	var exp
	func _init(t, v, e):
		type = t
		value = v
		exp = e

	func _to_string():
		return str([type, value, exp])

class SetNode:
	var type
	var value
	var exp
	var op
	func _init(n, o, e):
		type = P_SET
		value = n
		op = o
		exp = e

	func _to_string():
		return str([type, value, op, exp])

class ControlNode:
	var type
	var clauses = []

	func _init():
		type = P_CTRL

	func _to_string():
		return str([type, clauses])

class ControlClause:
	var cond
	var exps = []

	func _init(condition):
		cond = condition

	func _to_string():
		return str([cond, exps])

var errors = []

func get_errors():
	return errors

func set_error(err):# TODO: check them all
	errors.append(err)

var parsed_nodes = []

func parse(text: String):
	errors = []
	parsed_nodes = []
	var tokens := lex(text)
	if not _check_braces(tokens):
		set_error("Curly braces wrong.")
		return
	var in_braces := false
	var i := 0
	var start := 0
	while i < len(tokens):
		var tk = tokens[i]
		if in_braces:
			if tk.type == TK_PUNC:
				if tk.value == ";":
					if i > start: parsed_nodes.append(
						parse_statement(tokens, start, i)
					)
					start = i+1
				elif tk.value == "}":
					if i > start: parsed_nodes.append(
						parse_statement(tokens, start, i)
					)
					in_braces = false
		elif tk.type == TK_PUNC and tk.value == "{":
			start = i+1
			in_braces = true
		elif tk.type == TK_STRING:
			parsed_nodes.append(PNode.new(P_STR, tokens[i].value, null))
		i+=1
	if not _check_if_elif_ladder():
		parsed_nodes = []
		return

	var nodes
	var temp = ControlNode.new()
	temp.clauses = [
		ControlClause.new(null)
	]
	var data_stack = [
		temp
	]
	for node in parsed_nodes:
		if node.type == P_IF:
			data_stack.append(ControlNode.new())
			data_stack.back().clauses = [
				ControlClause.new(node.exp)
			]
		elif node.type == P_ELIF:
			data_stack.back().clauses.append(
				ControlClause.new(node.exp)
			)
		elif node.type == P_ELSE:
			data_stack.back().clauses.append(
				ControlClause.new(null)
			)
		elif node.type == P_ENDIF:
			var data = data_stack.pop_back()
			data_stack.back().clauses.back().exps.append(data)
		else:
			data_stack.back().clauses.back().exps.append(node)

	parsed_nodes = data_stack.back().clauses.back().exps

func parse_statement(tokens: Array, start: int, end: int):
	var tk = tokens[start]
	if tk.type == TK_WORD:
		if tk.value == "if":
			if end - start <= 1:
				set_error("Expected token after 'if'.")
				return PNode.new(P_IF, null, Token.new(TK_LITERAL, null))
			return PNode.new(P_IF, null, parse_expr(tokens, start+1, end))
		if tk.value == "elif":
			if end - start <= 1:
				set_error("Expected token after 'elif'.")
				return PNode.new(P_ELIF, null, Token.new(TK_LITERAL, null))
			return PNode.new(P_ELIF, null, parse_expr(tokens, start+1, end))
		if tk.value == "else":
			if end - start > 1:
				set_error("Unexpected token after 'else'.")
			return PNode.new(P_ELSE, null, null)
		if tk.value == "endif":
			if end - start > 1:
				set_error("Unexpected token after 'endif'.")
			return PNode.new(P_ENDIF, null, null)
	if end - start > 1:
		var tk1 = tokens[start+1]
		if tk1.type == TK_PUNC and tk1.value in [
			"=", "+=", "-=", "*=", "/=", "%="
		]:
			if end - start <= 2:
				set_error("Expected token after '{0}'.".format([tk1.value]))
				return
			if tk.type != TK_WORD:
				set_error("Expected variable before '{0}'".format(tk1.value))
				return
			else:
				return SetNode.new(tk.value, tk1.value, parse_expr(tokens, start+2, end))
	return PNode.new(P_EXP, null, parse_expr(tokens, start, end))

func _check_braces(tokens: Array):
	var c = 0
	for i in len(tokens):
		var tk = tokens[i]
		if tk.type == TK_PUNC:
			if tk.value == "{":
				c += 1
			elif tk.value == "}":
				c -= 1
				if c < 0:
					return false
	return c == 0

func _check_if_elif_ladder():
	var else_found_array = []
	for node in parsed_nodes:
		if node.type == P_IF:
			else_found_array.append(false)
		elif node.type == P_ELIF:
			if len(else_found_array) == 0:
				set_error("Unexpected 'elif'.")
				return false
			if else_found_array[-1]:
				set_error("Unexpected 'elif' after 'else'.")
				return false
		elif node.type == P_ELSE:
			if len(else_found_array) == 0:
				set_error("Unexpected 'else'.")
				return false
			if else_found_array[-1]:
				set_error("Multiple 'else'.")
				return false
			else_found_array[-1] = true
		elif node.type == P_ENDIF:
			if len(else_found_array) == 0:
				set_error("Unexpected 'endif'.")
				return false
			else_found_array.pop_back()
	if len(else_found_array) != 0:
		set_error("Expected 'endif'...")
		return false
	return true

class ParseExprData:
	var nodes:= []
	var call_name
	func _init(name):
		call_name = name


func parse_expr(tokens: Array, start: int, end: int):
	if not _check_parentheses(tokens, start, end):
		set_error("Parentheses wrong.")
		return Token.new(TK_LITERAL, null)
	fix_unary_minus(tokens, start, end)
	var i := start
	var data_stack = [
		ParseExprData.new(null)
	]
	while i < end:
		var tk = tokens[i]
		if tk.type == TK_PUNC and tk.value == "(":
			if i > start and tokens[i-1].type == TK_WORD:
				var temp = tokens[i-1].value
				data_stack.back().nodes.pop_back()
				data_stack.append(ParseExprData.new(temp))
			else:
				data_stack.append(ParseExprData.new(null))
		elif tk.type == TK_PUNC and tk.value == ")":
			var data = data_stack.pop_back()
			if data.call_name != null:
				var node = OpNode.new(TK_CALL, data.call_name)
				if len(data.nodes) == 0:
					node.nodes = []
				else:
					node.nodes = _parse_expr_args(data.nodes)
				data_stack.back().nodes.append(node)
			else:
				var exp = _parse_expr_simple(data.nodes)
				if exp == null:
					data_stack.back().nodes.append(Token.new(TK_LITERAL, null))
				else:
					data_stack.back().nodes.append(exp)
		else:
			data_stack.back().nodes.append(tk)
		i+=1
	var exp = _parse_expr_simple(data_stack.back().nodes)
	if exp == null:
		return Token.new(TK_LITERAL, null)
	else:
		return exp


func _check_parentheses(tokens: Array, start: int, end: int):
	var c = 0
	for i in range(start, end):
		var tk = tokens[i]
		if tk.type == TK_PUNC:
			if tk.value == "(":
				c += 1
			elif tk.value == ")":
				c -= 1
				if c < 0:
					return false
	return c == 0

func fix_unary_minus(tokens, start, end):
	var i = start
	while i < end:
		var tk = tokens[i]
		if tk.type == TK_PUNC and tk.value == "-":
			if i == start:
				tk.value = "-x"
			else:
				var tk1 = tokens[i-1]
				if tk1.type == TK_PUNC:
					if tk1.value != ")":
						tk.value = "-x"
		i+=1


var priority_dict = {
	"-x": 0,
	"*": 1,
	"/": 1,
	"%": 1,
	"+": 2,
	"-": 2,
	"<": 3,
	"<=": 3,
	">": 3,
	">=": 3,
	"==": 3,
	"!=": 3,
	"not": 4,
	"and": 5,
	"or": 6,
}

class OpNode:
	var type
	var value
	var nodes
	func _init(t, v):
		type = t
		value = v
	func _to_string():
		return str([type, value, nodes])

func _parse_expr_simple(tokens: Array):
	for i in len(tokens):
		var tk = tokens[i]
		if tk.type == TK_PUNC and tk.value == ",":
			set_error("Unexpected ','.")
			return
	while true:
		var min_priority = INF
		var j = -1
		for i in len(tokens):
			var tk = tokens[i]
			if tk.type == TK_PUNC and priority_dict.has(tk.value):
				var priority = priority_dict[tk.value]
				if min_priority > priority:
					min_priority = priority
					j = i
		if j == -1:
			if tokens.is_empty():
				return
			return tokens[0]
		var tk = tokens[j]
		if tk.value in [
			"-x",
			"not"
		]:
			var k = j
			while tokens[k].type == TK_PUNC:
				k+=1
				if k >= len(tokens):
					set_error("Unexpected end of expression...")
					return
			for p in range(k-1, j-1, -1):
				var node = OpNode.new(TK_OP, tokens[p].value)
				node.nodes = [
					tokens[p+1]
				]
				tokens[p] = node
				tokens.remove_at(p+1)
		else:
			if j+1 >= len(tokens):
				set_error("Unexpected end of expression...")
				return
			if j-1 < 0:
				set_error("Unexpected start of expression.")
				return
			var tk1 = tokens[j+1]
			var tk2 = tokens[j-1]
			if (
				tk1.type == TK_PUNC or
				tk2.type == TK_PUNC
			):
				set_error("Unexpected consecutive operators.")
				return
			var node = OpNode.new(TK_OP, tk.value)
			node.nodes = [tk2, tk1]
			tokens[j] = node
			tokens.remove_at(j+1)
			tokens.remove_at(j-1)

func _parse_expr_args(tokens: Array):
	var ret = []
	var start = 0
	for i in len(tokens):
		var tk = tokens[i]
		if tk.type == TK_PUNC and tk.value == ",":
			var exp = _parse_expr_simple(tokens.slice(start, i))
			if exp == null:
				ret.append(Token.new(TK_LITERAL, null))
			else:
				ret.append(exp)
			start = i+1
	var exp = _parse_expr_simple(tokens.slice(start))
	if exp == null:
		ret.append(Token.new(TK_LITERAL, null))
	else:
		ret.append(exp)
	return ret

func evaluate(domain, engine):
	return _evaluate(parsed_nodes, domain, engine)

func _evaluate(nodes, domain, engine):
	var ret := ""
	for node in nodes:
		if node == null:
			continue
		elif node.type == P_CTRL:
			for clause in node.clauses:
				if clause.cond == null or _evaluate_simple(clause.cond, domain, engine):
					ret += _evaluate(clause.exps, domain, engine)
					break
		elif node.type == P_STR:
			ret += node.value
		elif node.type == P_EXP:
			var res = _evaluate_simple(node.exp, domain, engine)
			if res != null:
				ret += str(res)
		elif node.type == P_SET:
			var b = _evaluate_simple(node.exp, domain, engine)
			if node.op == "=":
				engine.set_value(node.value, b, domain)
			else:
				var a = engine.get_value(node.value, domain)
				if node.op == "+=":
					a += b
				elif node.op == "-=":
					a -= b
				elif node.op == "*=":
					a *= b
				elif node.op == "/=":
					a /= b
				elif node.op == "%=":
					a %= b
				else:
					continue
				engine.set_value(node.value, a, domain)
	return ret

func evaluate_value(domain, engine):
	evaluate(domain, engine)
	var i = len(parsed_nodes) - 1
	while i >= 0:
		var node = parsed_nodes[i]
		if node.type == P_EXP:
			return _evaluate_simple(node.exp, domain, engine)
		i -= 1


func _evaluate_simple(exp, domain, engine): # TODO: propagate errors
	if exp == null:
		return null
	if exp.type == TK_WORD:
		return engine.get_value(exp.value, domain)
	if exp.type == TK_LITERAL:
		return exp.value
	if exp.type == TK_OP:
		var a
		var b
		if len(exp.nodes) > 0:
			a = _evaluate_simple(exp.nodes[0], domain, engine)
		if len(exp.nodes) > 1:
			b = _evaluate_simple(exp.nodes[1], domain, engine)
		if exp.value == "-x":
			return - a
		if exp.value == "*":
			return a * b
		if exp.value == "/":
			return a / b
		if exp.value == "%":
			return a % b
		if exp.value == "+":
			return a + b
		if exp.value == "-":
			return a - b
		if exp.value == "<":
			return a < b
		if exp.value == "<=":
			return a <= b
		if exp.value == ">":
			return a > b
		if exp.value == ">=":
			return a >= b
		if exp.value == "==":
			return a == b
		if exp.value == "!=":
			return a != b
		if exp.value == "not":
			return not a
		if exp.value == "and":
			return a and b
		if exp.value == "or":
			return a or b
	if exp.type == TK_CALL:
		if exp.value == "NAME":
			if len(exp.nodes) < 1:
				return
			var node = exp.nodes[0]
			if node.type != TK_WORD:
				return
			return {
				"key": node.value,
				"domain": domain,
			}
		var args = []
		for node in exp.nodes:
			args.append(_evaluate_simple(node, domain, engine))
		return engine.do_call(exp.value, args, domain)

