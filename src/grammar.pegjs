start
  = top_blocks

top_blocks = top_block*


top_block
  = __ name:identifer __ inherits:inherits_reference? __ block_values:block __ {
    var inherits_val = inherits.length == 0 ? null : inherits;
    return { type: "top_block", inherits: inherits_val, name: name, value: block_values };
  }


block
  = "{" end_of_line __ inside:properties __ "}" end_of_line {
    return { type: "block", value: inside };
  }


inherits_reference
 = __ "<-" __ name:identifer __ { return name; }


properties = property+

property
  = __ name:identifer __ "->" __ value:property_value end_of_line? {
    return { type: "property", name: name, value: value };
  }

property_value
  = string_property / bool_property / integer_property / identifer_property / block_property


block_property
  = block

bool_property
  = value:bool_literal { return { type: "bool", value: value }; }

string_property
 = value:string_literal { return { type: "string", value: value }; }

integer_property
  = value:integer { return { type: "integer", value: value }; }

identifer_property
  = value:identifer { return { type: "reference", value: value }; }


identifer "identifer"
  = first:[a-zA-Z] rest:[a-zA-Z0-9_]* { return first + rest.join(""); }


_ "whitespace"
  = [\t\v\f\n\r \u00A0\uFEFF]

__ "whitespace" = _*
end_of_line = "\n" / "\r" / "\r\n" / EOF
EOF = !.


integer = digits:[0-9]+ { return parseInt(digits.join(""), 10); }

string_literal = parts:("'" string "'") { return parts[1]; }
string = chars:string_char+ { return chars.join(""); }
string_char = !("'") char_:. { return char_;     }

bool_literal = value:( "true" / "false" ) { return value == "true" ? true : false; }
