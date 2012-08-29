$     = Spine.$
Gfx   = require('gfx')
Stage = require('./stage')

class Panel extends Stage
  title: false

  constructor: ->
    super
    @el.removeClass('stage').addClass('panel')
    @header.append($('<h2 />'))
    @setTitle(@title) if @title
    @stage ?= Stage.globalStage()
    @stage?.add(@)
    
  setTitle: (title = '') ->
    @header.find('h2:first').html(title)
    
  addButton: (text, callback) ->
    callback = @[callback] if typeof callback is 'string'
    button = $('<button />').text(text)
    button.tap(@proxy(callback))
    @header.append(button)
    button
  
  activate: (params = {}) ->
    effect = params.transition or params.trans
    if effect
      @effects[effect].apply(this)
    else
      @el.show()
      @el.addClass('active')

  deactivate: (params = {}) ->
    return unless @isActive()
    effect = params.transition or params.trans
    if effect
      @reverseEffects[effect].apply(this)
    else
      @el.removeClass('active')
  
  effects:
    left: ->
      @el.addClass('active')
      @el.gfxSlideIn(@effectOptions(direction: 'left'))
    
    right: ->
      @el.addClass('active')
      @el.gfxSlideIn(@effectOptions(direction: 'right'))
  
  reverseEffects:
    left: ->
      @el.gfxSlideOut(@effectOptions(direction: 'right'))
      @el.queueNext => 
        @el.removeClass('active')
    
    right: ->
      @el.gfxSlideOut(@effectOptions(direction: 'left'))
      @el.queueNext => 
        @el.removeClass('active')
        
(module?.exports = Panel) or @Panel = Panel