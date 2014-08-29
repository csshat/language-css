css = require('octopus-helpers').css
utils = require('octopus-helpers').utils

# Helpers
px = css.px
color = css.color

trimName = (value) ->
  value = value.trim().replace(/\s{2,}/, ' ')

  if value.length > 14
    value = value.slice(0, 14)
    value += '…'

  return value

selector = ({options, name, type, id}) ->
  dictionary =
    'dash-case': 'dash'
    'camelCase': 'camel'
    'snake_case': 'snake'

  style = dictionary[options.selectorTextStyle] or 'dash'

  switch options.selectorType
    when 'id' then prefix = '#'
    when 'class' then prefix = '.'
    else prefix = ''

  name = utils.format(name, style)

  name = (type.toLowerCase() + id) if not name.length

  return prefix + name



# Exports
exports.px = px
exports.color = color
exports.trimName = trimName
exports.selector = selector