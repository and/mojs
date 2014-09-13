Byte      = require './byte'

class Bubble extends Byte
  vars:->
    super

    @spikes    = @default prop: 'spikes',    def: 5
    @spikesEnd = @default prop: 'spikesEnd', def: @spikes

    @rate      = @default prop: 'rate',    def: .25
    @rateEnd   = @default prop: 'rateEnd', def: @rate

  run:(@oa={}, from)->
    super; it = @
    if !@oa.isChain
      @from =
        radiusX:      @radiusX
        radiusY:      @radiusY
        lineWidth:    @lineWidth
        angle:        @angleStart
        opacity:      @opacity
        lineDashOffset: @lineDashOffset
        spikes:       @spikes
        rate:         @rate
    else @from = from
    @to =
      radiusX:      @radiusXEnd
      radiusY:      @radiusYEnd
      lineWidth:    @lineWidthEnd
      angle:        @angleEnd
      opacity:      @opacityEnd
      lineDashOffset: @lineDashOffsetEnd
      spikes:       @spikesEnd
      rate:         @rateEnd

    @mixStarSpikesProps()
    @mixLineDash()
    @mixColor(@oa.isChain)
    @mixFill(@oa.isChain)

    @calcSize()
    @addElements()

    tween = @initTween(@oa.isChain).onUpdate -> it.draw.call(@, it)
    @tweens.push tween


  draw:(it)->
    it.rotate angle: @angle*it.h.DEG
    # console.clear()
    # console.log @rate

    it.object.setProp
      radiusX:    @radiusX/2
      radiusY:    @radiusY/2
      position:   x: 2*it.center, y: 2*it.center
      lineWidth:  @lineWidth
      lineDash:   it.updateLineDash(@)
      colorObj:   it.updateColor(@)
      fillObj:    it.updateFill(@)
      opacity:    @opacity
      spikes:     @spikes
      rate:       @rate
      lineDashOffset: @lineDashOffset

    it.ctx.restore()


  addElements:->
    Shape = @shapes[@shape.toLowerCase()] or Circle

    @object = new Shape
      ctx: @ctx
      position:   x: @center, y: @center
      # rate:     @rate
      lineCap:  @lineCap
      # spikes:   @spikes
      lineDash: @lineDash
      fill:     @fill

  mixStarSpikesProps:->
    @from.spikes = @spikes
    @to.spikes   = @spikesEnd

    # @from.rate = @rate
    # @to.rate   = @rateEnd

module.exports = Bubble