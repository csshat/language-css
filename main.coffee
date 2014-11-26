{px, colorFormat, trimName, selector, comment} = require('./helpers')

class CSS

  fontStyles: ({font, color}, $$) ->
    $$ 'color: %s;', colorFormat(color, @options.colorType) if color?
    $$ 'font-family: "%s";', font.name if font?.name?
    $$ 'font-size: %s;', px(font.size) if font?.size?
    $$ 'font-weight: %s;', font.weight if font?.weight?
    $$ 'font-style: %s;', font.style if font?.style?
    if font?.underline?
      $$ 'text-decoration: %s;', 'underline'
    else if font?.linethrough?
      $$ 'text-decoration: %s;', 'line-through'

  render: ($) ->
    $$ = $.indents
    baseTextComment = 'Base text style'
    textComment = 'Text style for'
    cssComment = 'Style for'

    # This options add explaining comment about CSS code below
    if @options.showTextSnippet
      if @textStyles?
        if @textStyles.length > 1 and @options.inheritFontStyles?
          $ comment(baseTextStyle)
        else
          $ comment(textComment), trimName(@name)
      else
        $ comment(cssComment), trimName(@name)

    # This option add selector according to name of the layer
    if @options.selector
        $ '%s {', selector(@)

    $$ 'opacity: %s;', @opacity if @opacity?

    if @bounds?
      $$ 'width: %s;', px(@bounds.width)
      $$ 'height: %s;', px(@bounds.height)

    if @options.inheritFontStyles and @baseTextStyle?
      @fontStyles(@baseTextStyle, $$)

    if @textStyles?
      @fontStyles(textStyle, $$) for textStyle in @textStyles

    # Close block code definition if selector option is choosen
    if @options.selector
        $ '}'


exports.renderClass = CSS
