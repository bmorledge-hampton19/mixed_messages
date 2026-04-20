extends Control

@export var drBeanControl: Control
@export var drBeanSprite: Sprite2D
@export var drBeanAnimationPlayer: AnimationPlayer

@export var idleTexture: Texture2D
@export var focusedOnFlaskTexture: Texture2D
@export var focusedOnComputerTexture: Texture2D
@export var surprisedByFlaskTexture: Texture2D
@export var surprisedByComputerTexture: Texture2D

@export var noise: FastNoiseLite

@export var guessing_letters: Array[GuessingLetter]

var fadeInDelay: float = 1.0
var fadingIn: bool
var fadeInDuration: float = 2.0

var timeUntilFadeOut: float = 10.0
var fadingOut: bool
var fadeOutDuration: float = 2.0

var spriteAnchor: Vector2

enum BeanState {IDLE, FOCUSED_ON_FLASK, FOCUSED_ON_COMPUTER, SURPRISED_BY_FLASK, SURPRISED_BY_COMPUTER}
var beanState: BeanState
var texturesByBeanState: Dictionary
var hFramesByBeanState: Dictionary

var jittering: bool
var noisePos: float
var jitterSpeed: float = 7.5

func updateAnimation():
	drBeanAnimationPlayer.play(BeanState.keys()[beanState].to_lower())
	drBeanSprite.texture = texturesByBeanState[beanState]
	drBeanSprite.hframes = hFramesByBeanState[beanState]


func _ready():

	texturesByBeanState = {
		BeanState.IDLE : idleTexture,
		BeanState.FOCUSED_ON_FLASK : focusedOnFlaskTexture, BeanState.FOCUSED_ON_COMPUTER : focusedOnComputerTexture,
		BeanState.SURPRISED_BY_FLASK : surprisedByFlaskTexture, BeanState.SURPRISED_BY_COMPUTER : surprisedByComputerTexture,
	}
	hFramesByBeanState = {
		BeanState.IDLE : 11,
		BeanState.FOCUSED_ON_FLASK : 8, BeanState.FOCUSED_ON_COMPUTER : 10,
		BeanState.SURPRISED_BY_FLASK : 5, BeanState.SURPRISED_BY_COMPUTER : 10,
	}

	drBeanControl.modulate.a = 0
	beanState = BeanState.IDLE

	spriteAnchor = drBeanSprite.position

	for guessing_letter in guessing_letters:
		guessing_letter.init(guessing_letter.text, true)
		guessing_letter.self_modulate = Color.WHITE



func _process(delta):

	processFades(delta)
	if jittering: processJitter(delta)
	

func processFades(delta):
	if fadeInDelay > 0:
		fadeInDelay -= delta
		if fadeInDelay <= 0:
			fadingIn = true
			updateAnimation()
	
	if fadingIn:
		drBeanControl.modulate.a += delta/fadeInDuration
		if drBeanControl.modulate.a >= 1:
			drBeanControl.modulate.a = 1
			fadingIn = false
	
	if timeUntilFadeOut > 0:
		timeUntilFadeOut -= delta
		if timeUntilFadeOut <= 0: fadingOut = true
	
	if fadingOut:
		drBeanControl.modulate.a -= delta/fadeOutDuration
		if drBeanControl.modulate.a <= 0:
			drBeanControl.modulate.a = 0
			fadingOut = false
			drBeanAnimationPlayer.stop()
			get_tree().create_timer(0.5).timeout.connect(transitionToNextScene)


func processJitter(delta):
	noisePos += delta*jitterSpeed
	drBeanSprite.position = Vector2(
		round(noise.get_noise_2d(0, noisePos)*2.4)*4,
		round(noise.get_noise_2d(100, noisePos)*2.4)*4
	) + spriteAnchor


func clickOnRightHandProp():
	if fadingOut or drBeanControl.modulate.a == 0: return
	if beanState == BeanState.IDLE:
		beanState = BeanState.FOCUSED_ON_FLASK
		updateAnimation()
		timeUntilFadeOut = 4.0
	elif beanState == BeanState.FOCUSED_ON_COMPUTER:
		beanState = BeanState.SURPRISED_BY_FLASK
		updateAnimation()
		jittering = true
		timeUntilFadeOut = 4.0

func clickOnLeftHandProp():
	if fadingOut or drBeanControl.modulate.a == 0: return
	if beanState == BeanState.IDLE:
		beanState = BeanState.FOCUSED_ON_COMPUTER
		updateAnimation()
		timeUntilFadeOut = 4.0
	elif beanState == BeanState.FOCUSED_ON_FLASK:
		beanState = BeanState.SURPRISED_BY_COMPUTER
		updateAnimation()
		jittering = true
		timeUntilFadeOut = 4.0


func transitionToNextScene():
	get_tree().change_scene_to_file("res://main.tscn")
