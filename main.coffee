# Deps

autoprefixer = require('autoprefixer-core')
{css, utils} = require 'octopus-helpers'
{_} = utils


# Private fns

_declaration = ($, vendorPrefixes, prefixer, property, value, modifier) ->
  return if not value? or value == ''
  value = modifier(value) if modifier
  return prefixer(property, value) if vendorPrefixes
  $ "#{property}: #{value};"


_comment = ($, showComments, text) ->
  return unless showComments
  $ "/* #{text} */"


defineVariable = (name, value, options) ->
  # TODO: add :root selector when selectorOptions is enabled
  "--#{name}: #{value};"


renderVariable = (name) ->
  "var(--#{name})"

renderColor = (color, colorVariable, colorType) ->
  if color.a < 1
    css.colorFormat(color, colorType)
  else
    renderVariable(colorVariable)

_convertColor = _.partial(css.convertColor, renderColor)

_startSelector = ($, selector, selectorOptions, text) ->
  return unless selector
  $ '%s%s', utils.prettySelectors(text, selectorOptions), ' {'


_endSelector = ($, selector) ->
  return unless selector
  $ '}'


prefixer = null
setAutoprefixer = (prefixOptions = '> 1%, last 2 versions, Firefox ESR, Opera 12.1') ->
  options = prefixOptions.split(',').map (val) -> val.trim()

  try
    prefixer = autoprefixer({browsers: options})
  catch e
    'Parse error – try to check the syntax'

setNumberValue = (number) ->
  converted = parseInt(number, 10)
  if not number.match(/^\d+(\.\d+)?$/)
    return 'Please enter numeric value'
  else
    return converted


_prefixed = ($, property, value) ->
  setAutoprefixer() unless prefixer

  output = "#{property}: #{value}"
  prefixed = prefixer.process(output)

  children = prefixed.root.childs
  $ "#{child.prop}: #{child.value};" for child in children


declareAbsolutePosition = (declaration, bounds, unit) ->
  declaration('position', 'absolute')
  declaration('left', bounds.left, unit)
  declaration('top', bounds.top, unit)


declareDimensions = (declaration, bounds, unit) ->
  declaration('width', unit(bounds.width))
  declaration('height', unit(bounds.height))


class CSS

  render: ($) ->
    $$ = $.indents
    prefixed = _.partial(_prefixed, $$)
    declaration = _.partial(_declaration, $$, @options.vendorPrefixes, prefixed)
    comment = _.partial(_comment, $, @options.showComments)
    boxModelDimension = _.partial(css.boxModelDimension, @options.boxSizing, if @borders then @borders[0].width else null)

    rootValue = switch @options.unit
      when 'px' then 0
      when 'em' then @options.emValue
      when 'rem' then @options.remValue
    unit = _.partial(css.unit, @options.unit, rootValue)

    lhRoot = switch @options.lineHeightUnit
      when 'px' then 0
      when 'em' then @options.emValue
      when 'rem' then @options.remValue
    lineHeightUnit = _.partial(css.lineHeightUnit, @options.lineHeightUnit, unit, lhRoot)
    isUnitlessLh = @options.lineHeightUnit.toLowerCase().indexOf('unitless') isnt -1

    convertColor = _.partial(_convertColor, @options)
    fontStyles = _.partial(css.fontStyles, declaration, convertColor, unit, lineHeightUnit, isUnitlessLh, @options.quoteType)

    selectorOptions =
      separator: @options.selectorTextStyle
      selector: @options.selectorType
      maxWords: 3
      fallbackSelectorPrefix: 'layer'
    startSelector = _.partial(_startSelector, $, @options.selector, selectorOptions)
    endSelector = _.partial(_endSelector, $, @options.selector)

    if @type == 'textLayer'
      if @baseTextStyle and @textStyles
        for textStyle in css.prepareTextStyles(@options.inheritFontStyles, @baseTextStyle, @textStyles)

          comment(css.textSnippet(@text, textStyle))

          if @options.selector
            if textStyle.ranges
              selectorText = utils.textFromRange(@text, textStyle.ranges[0])
            else
              selectorText = @name

            startSelector(selectorText)

          if not @options.inheritFontStyles or textStyle.base
            if @options.showAbsolutePositions
              declareAbsolutePosition(declaration, @bounds, unit)

            if @bounds
              declareDimensions(declaration, @bounds, unit)

            declaration('opacity', @opacity)

            if @shadows
              declaration('text-shadow', css.convertTextShadows(convertColor, unit, @shadows))

          fontStyles(textStyle)

          endSelector()
      else
        startSelector(@name)
        comment('Text dimensions')
        if @options.showAbsolutePositions
            declareAbsolutePosition(declaration, @bounds, unit)

        if @bounds
          declareDimensions(declaration, @bounds, unit)

        endSelector()

      $.newline()
    else
      comment("Style for \"#{utils.trim(@name)}\"")
      startSelector(@name)

      if @options.showAbsolutePositions
        declareAbsolutePosition(declaration, @bounds, unit)

      if @bounds
        width = boxModelDimension(@bounds.width)
        height = boxModelDimension(@bounds.height)

        declareDimensions(declaration, { width, height }, unit)

      declaration('opacity', @opacity)

      if @background
        declaration('background-color', @background.color, convertColor)

        if @background.gradient
          declaration('background-image', css.convertGradients(convertColor, {gradient: @background.gradient, @bounds}))

      if @borders
        border = @borders[0]
        declaration('border', "#{unit(border.width)} #{border.style} #{convertColor(border.color)}")

      declaration('border-radius', @radius, _.partial(css.radius, unit))

      if @shadows
        declaration('box-shadow', css.convertShadows(convertColor, unit, @shadows))

      endSelector()

metadata = require './package.json'

module.exports = {defineVariable, renderVariable, setAutoprefixer, setNumberValue, renderClass: CSS, metadata}
