this["DSpace"] = this["DSpace"] || {};
this["DSpace"]["templates"] = this["DSpace"]["templates"] || {};

this["DSpace"]["templates"]["discovery_advanced_filters"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, options, functionType="function", escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing, blockHelperMissing=helpers.blockHelperMissing;

function program1(depth0,data,depth1) {
  
  var buffer = "", stack1, stack2, options;
  buffer += "\n<div id=\"aspect_discovery_SimpleSearch_row_filter-new-";
  if (stack1 = helpers.index) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.index; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"\n     class=\"ds-form-item row advanced-filter-row search-filter\">\n    <div class=\"col-xs-4 col-sm-2\">\n        <p>\n            <select id=\"aspect_discovery_SimpleSearch_field_filtertype_";
  if (stack1 = helpers.index) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.index; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" class=\"ds-select-field form-control\"\n                    name=\"filtertype_";
  if (stack1 = helpers.index) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.index; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">\n                ";
  options = {hash:{},inverse:self.noop,fn:self.programWithDepth(2, program2, data, depth1),data:data};
  stack2 = ((stack1 = helpers.set_selected || depth0.set_selected),stack1 ? stack1.call(depth0, depth0.type, options) : helperMissing.call(depth0, "set_selected", depth0.type, options));
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n            </select>\n        </p>\n    </div>\n    <div class=\"col-xs-4 col-sm-2\">\n        <p>\n            <select id=\"aspect_discovery_SimpleSearch_field_filter_relational_operator_";
  if (stack2 = helpers.index) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.index; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  buffer += escapeExpression(stack2)
    + "\"\n                    class=\"ds-select-field form-control\" name=\"filter_relational_operator_";
  if (stack2 = helpers.index) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.index; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  buffer += escapeExpression(stack2)
    + "\">\n                ";
  options = {hash:{},inverse:self.noop,fn:self.programWithDepth(5, program5, data, depth1),data:data};
  stack2 = ((stack1 = helpers.set_selected || depth0.set_selected),stack1 ? stack1.call(depth0, depth0.relational_operator, options) : helperMissing.call(depth0, "set_selected", depth0.relational_operator, options));
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n            </select>\n        </p>\n    </div>\n    <div class=\"col-xs-4 col-sm-6\">\n        <p>\n            <input id=\"aspect_discovery_SimpleSearch_field_filter_";
  if (stack2 = helpers.index) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.index; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  buffer += escapeExpression(stack2)
    + "\"\n                   class=\"ds-text-field form-control discovery-filter-input discovery-filter-input\"\n                   name=\"filter_";
  if (stack2 = helpers.index) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.index; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  buffer += escapeExpression(stack2)
    + "\" type=\"text\" value=\"";
  if (stack2 = helpers.query) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.query; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  buffer += escapeExpression(stack2)
    + "\">\n        </p>\n    </div>\n    <div class=\"hidden-xs col-sm-2\">\n        <div class=\"btn-group btn-group-justified\">\n                <p class=\"btn-group\">\n                    <button id=\"aspect_discovery_SimpleSearch_field_add-filter_";
  if (stack2 = helpers.index) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.index; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  buffer += escapeExpression(stack2)
    + "\"\n                            class=\"ds-button-field btn btn-default filter-control filter-add filter-control filter-add\"\n                            name=\"add-filter_";
  if (stack2 = helpers.index) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.index; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  buffer += escapeExpression(stack2)
    + "\" type=\"submit\" title=\"Add Filter\"><span\n                            class=\"glyphicon glyphicon-plus-sign\" aria-hidden=\"true\"></span></button>\n                </p>\n                <p class=\"btn-group\">\n                    <button id=\"aspect_discovery_SimpleSearch_field_remove-filter_";
  if (stack2 = helpers.index) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.index; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  buffer += escapeExpression(stack2)
    + "\"\n                            class=\"ds-button-field btn btn-default filter-control filter-remove filter-control filter-remove\"\n                            name=\"remove-filter_";
  if (stack2 = helpers.index) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = depth0.index; stack2 = typeof stack2 === functionType ? stack2.apply(depth0) : stack2; }
  buffer += escapeExpression(stack2)
    + "\" type=\"submit\" title=\"Remove\"><span\n                            class=\"glyphicon glyphicon-minus-sign\" aria-hidden=\"true\"></span></button>\n                </p>\n        </div>\n    </div>\n</div>\n";
  return buffer;
  }
function program2(depth0,data,depth2) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n                ";
  stack2 = helpers.each.call(depth0, ((stack1 = depth2.i18n),stack1 == null || stack1 === false ? stack1 : stack1.filtertype), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n                ";
  return buffer;
  }
function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n                <option value=\""
    + escapeExpression(((stack1 = ((stack1 = data),stack1 == null || stack1 === false ? stack1 : stack1.key)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">"
    + escapeExpression((typeof depth0 === functionType ? depth0.apply(depth0) : depth0))
    + "</option>\n                ";
  return buffer;
  }

function program5(depth0,data,depth2) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n                ";
  stack2 = helpers.each.call(depth0, ((stack1 = depth2.i18n),stack1 == null || stack1 === false ? stack1 : stack1.filter_relational_operator), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n                ";
  return buffer;
  }

  buffer += "<!--\n\n    The contents of this file are subject to the license and copyright\n    detailed in the LICENSE and NOTICE files at the root of the source\n    tree and available online at\n\n    http://www.dspace.org/license/\n\n-->\n";
  options = {hash:{},inverse:self.noop,fn:self.programWithDepth(1, program1, data, depth0),data:data};
  if (stack1 = helpers.filters) { stack1 = stack1.call(depth0, options); }
  else { stack1 = depth0.filters; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  if (!helpers.filters) { stack1 = blockHelperMissing.call(depth0, stack1, options); }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer;
  });

this["DSpace"]["templates"]["discovery_simple_filters"] = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <label href=\"#\" class=\"label label-primary\" data-index=\"";
  if (stack1 = helpers.index) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.index; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (stack1 = helpers.query) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.query; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "&nbsp;&times;</label>\n";
  return buffer;
  }

  buffer += "<!--\n\n    The contents of this file are subject to the license and copyright\n    detailed in the LICENSE and NOTICE files at the root of the source\n    tree and available online at\n\n    http://www.dspace.org/license/\n\n-->\n";
  stack1 = helpers.each.call(depth0, depth0.orig_filters, {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer;
  });