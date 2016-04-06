chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'weather', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/weather')(@robot)

  it 'registers a respond weather of listener', ->
    expect(@robot.respond).to.have.been.calledWith(/weather of (.*)/i)

  it 'registers a respond what is exactly called listener', ->
    expect(@robot.respond).to.have.been.calledWith(/what is (.*) (exactly|exact) (called|named|call|name)[\?]?/i)
