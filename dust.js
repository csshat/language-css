var css = require('octopus-helpers').css;

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
        var fontStyles = css.fontStyleNameToCSS(params.font.type);

        for (var j = 0, jLength = fontStyles.length; j < jLength; j++) {
            var fontStyle = fontStyles[j];
            params.font[fontStyle.property] = fontStyle.value;
        }

        return chunk.render(bodies.block, ctx.push(params.font));
    },
    color: function(chunk, ctx, bodies, params) {
        var color = ctx.get('color');
        return chunk.write(css.color(color));
    }
};

exports.filters = filters;
exports.helpers = helpers;
