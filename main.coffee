_ = require('./helpers')

class CSS

  render: ($) ->
    styleForText = '/* Style for "%s" */'

    # This options add explaining comment about code below
    if @options.showTextSnippet
      if @textStyles?
        if @textStyles.length > 1 && @options.inheritFontStyles?
          $ '/* Base style */'
        else
          $ styleForText, _.trimName(@name)
      else
        $ styleForText, _.trimName(@name)

    # This option add selector according to name of the layer
    if @options.selector
        $ '%s {', _.selector(@)

    $ '\topacity: %s;', @opacity if @opacity?

    if @bounds
      $ '\twidth: %s;', _.px(@bounds.width)
      $ '\theight: %s;', _.px(@bounds.height)

    if @textStyles?
      for {font, color} in @textStyles
        $ '\tfont-family: "%s";', font.name if font.name?
        $ '\tfont-size: %s;', _.px(font.size) if font.size?
        $ '\tfont-weight: %s;', font.weight if font.weight?
        $ '\tfont-style: %s;', font.style if font.style?

    # Close block code definition if selector option is choosen
    if @options.selector
        $ '}'


exports.renderClass = CSS
