config = require './_connection'
assert = require 'assert'

session = require 'express-session'
MSSQLStore = require('../src/store') session

SAMPLE =
	somevalue: "yes"
	somenumber: 111
	cookie: expires: new Date()

describe 'connect-mssql', ->
	store = null
	
	before (done) ->
		store = new MSSQLStore config
		store.clear done
	
	it 'should not find a session', (done) ->
		store.get 'asdf', (err, session) ->
			if err then return done err
			
			assert.ok !session
			
			done()
	
	it 'should create new session', (done) ->
		store.set 'asdf', SAMPLE, done
	
	it 'should get created session', (done) ->
		store.get 'asdf', (err, session) ->
			if err then return done err
			
			assert.strictEqual session.somevalue, SAMPLE.somevalue
			assert.strictEqual session.somenumber, SAMPLE.somenumber
			assert.equal session.cookie.expires, SAMPLE.cookie.expires.toISOString()
			
			done()
	
	it 'should remove created session', (done) ->
		store.destroy 'asdf', done
	
	it 'should have no session in db', (done) ->
		store.length (err, length) ->
			if err then return done err
			
			assert.equal length, 0
			
			done()