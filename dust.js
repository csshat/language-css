var css = require('octopus-helpers').css;
var utils = require('octopus-helpers').utils;

// Options: selector, selectorTextStyle, selectorType, vendorPrefixes, colorType, inheritFontStyles, showTextSnippet

var filters = {
    px: css.px,
    radius: css.radius,
    gradientAngle: function(angle) {
        return new css.GradientAngle(angle).toOldCssString();
    },
    css3GradientAngle: function(angle) {
        return new css.GradientAngle(angle).toNewCssString();
    }
};

var helpers = {
    font: function(chunk, ctx, bodies, params) {
        if (params.font.type === undefined) {
            return chunk.render(bodies.block, ctx.push(params.font));
        }

        var fontStyles = css.fontStyleNameToCSS(params.font.type);

        for (var j = 0, jLength = fontStyles.length; j < jLength; j++) {
            var fontStyle = fontStyles[j];
            params.font[fontStyle.property] = fontStyle.value;
        }

        return chunk.render(bodies.block, ctx.push(params.font));
    },
    color: function(chunk, ctx, bodies, params) {
        var color = ctx.get('color');
        var type = params.type || 'hex';
        return chunk.write(css.color(color, type));
    },
    selector: function(chunk, ctx, bodies, params) {
        var data = ctx.get('name');
        var index = '';
        var prefix = '';
        var range = null;
        var dictionary = {
          "dash-case" : "dash",
          "camelCase": "camel",
          "snake_case": "snake"
        };
        var style = dictionary[params.style] || 'dash';
        var type = '.';
        if (params.type === 'id') {
          type = '#';
        } else if (params.type === 'element') {
          type = '';
        }

        if (params.ranges) {
          index = params.index;
          range = params.ranges[index].ranges[0];
          data = ctx.get('text').substring(range.from, range.to);
        }

        var format = utils.format(data, style);

        if (params.isText != '0') {
          prefix = 'textStyle-';
        }

        format = prefix + (format && format || index);

        return chunk.write(type + format);
    },
    textSnippet: function(chunk, ctx, bodies, params) {
      var data = ctx.get('name');
      if (params.ranges) {
        var index = params.index;
        var range = params.ranges[index].ranges[0];
        data = ctx.get('text').substring(range.from, range.to);
      }

      data = 'Style for "' + data.slice(0, 14) + '"';

      return chunk.write('/* ' + data + ' */');
    }
};

exports.filters = filters;
exports.helpers = helpers;
