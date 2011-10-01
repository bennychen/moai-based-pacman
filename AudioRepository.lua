--
--------------------------------------------------------------------------------
--         FILE:  AudioRepository.lua
--        USAGE:  ./AudioRepository.lua 
--  DESCRIPTION:  declare all the needed audio resources
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  10/01/2011 17:00:38 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--


AUDIO_REPOSITORY = {}

function AUDIO_REPOSITORY.init()
	MOAIUntzSystem.initialize ()

	backgroundMusic = MOAIUntzSound.new()
	backgroundMusic:load( "media/backmusic.wav" )
	backgroundMusic:setVolume( 1 )
	backgroundMusic:setLooping( true )

	stageIntroSound = MOAIUntzSound.new()
	stageIntroSound:load( "media/ready.wav" )
	stageIntroSound:setVolume( 1 )
	stageIntroSound:setLooping( false )

	playingSound = MOAIUntzSound.new()
	playingSound:load( "media/playing.wav" )
	playingSound:setVolume( 1 )
	playingSound:setLooping( true )

	pauseSound = MOAIUntzSound.new()
	pauseSound:load( "media/pause.wav" )
	pauseSound:setVolume( 1 )
	pauseSound:setLooping( false )

	superStateSound = MOAIUntzSound.new()
	superStateSound:load( "media/super.wav" )
	superStateSound:setVolume( 1 )
	superStateSound:setLooping( true )

	pacmanDeadSound = MOAIUntzSound.new()
	pacmanDeadSound:load( "media/pacmandead.wav" )
	pacmanDeadSound:setVolume( 1 )
	pacmanDeadSound:setLooping( false )
	
	ghostDeadSound = MOAIUntzSound.new()
	ghostDeadSound:load( "media/monsterdead.wav" )
	ghostDeadSound:setVolume( 1 )
	ghostDeadSound:setLooping( false )

	winSound = MOAIUntzSound.new()
	winSound:load( "media/win.wav" )
	winSound:setVolume( 1 )
	winSound:setLooping( false )
end
