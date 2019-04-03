extends Reference


static func start(source: Object) -> String:
	var rewrite: String
	rewrite += "%s" % source.extend
	for method in source.methods:
		rewrite += _rewrite_method(method)
	return rewrite
	
static func _rewrite_method(method: Dictionary) -> String:
	var rewritten_method: String = "func %s(%s)%s%s"
	var title: String = method.name
	var parameters: String = _rewrite_parameters(method.parameters)
	var retval: String = _rewrite_retval(method.retval)
	var body: String = _rewrite_body(title, method.parameters)
	var rewrite = rewritten_method % [title, parameters, retval, body]
	return rewrite
	
static func _rewrite_parameters(parameters: Array) -> String:
	var result: String = ""
	for param in parameters:
		if param.typed:
			result += "%s:%s, " % [param.name, param.type]
		else:
			result += "%s," % [param.name]
	result = result.rstrip(", ")
	return result
	
static func _rewrite_retval(retval: Dictionary) -> String:
	if retval.typed:
		return " -> %s:" % retval.type
	return ":"
	
static func _rewrite_body(title, parameters) -> String:
	var args: String = "\n\tvar arguments = {"
	for param in parameters:
		args += ' "%s": %s,' % [param.name, param.name]
	args = args.rstrip(",").replace("{ ", "{") + "}".dedent()
	args = args.replace('{"": }', "{}") # In case its empty
	var retval: String = '\n\treturn self.get_meta("double").get_retval("%s", arguments)\n\n' % title
	return args + retval

#func _retval_delegate(identifier: String) -> String:
#	return "\n\treturn self.get_meta('double').get_retval('%s', parameters)\n" % identifier