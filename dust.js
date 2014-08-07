var css = require('octopus-helpers').css;
var utils = require('octopus-helpers').utils;

// Options: selector, selectorTextStyle, selectorType, vendorPrefixes, colorType, inheritFontStyles

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
        var style = params.style || 'dash';
        var type = '.';
        if (params.type === 'id') {
          type = '#';
        } else if (params.type === 'element') {
          type = '';
        }

        if (params.ranges) {
          var index = params.index;
          var range = params.ranges[index].ranges[0];
          data = ctx.get('text').substring(range.from, range.to);
        }

        return chunk.write(type + utils.format(data, style));
    }
};

exports.filters = filters;
exports.helpers = helpers;
