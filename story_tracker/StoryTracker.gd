class_name StoryTracker extends Node

@export var incoming_message_prefab: PackedScene
@export var outgoing_message_prefab: PackedScene

enum MessageType {INCOMING, OUTGOING}
class MessageData:
	var type: MessageType
	var text: String
	var missing_letter_rate: float
	func _init(p_type: MessageType, p_text: String, p_missing_letter_rate := 1.0):
		type = p_type
		text = p_text
		missing_letter_rate = p_missing_letter_rate

var messages: Array[MessageData] = [
	MessageData.new(
		MessageType.INCOMING,
		"Hello, this is Lookout Bravo. Do you read me?",
		0.25
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Lookout Bravo, this is Christie from the ranger station. Your connection is subpar, but it's workable. " +
		"What can I help you with?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Oh wow. I wasn't expecting to get a response this late in the day... How, uh... How are you doing?",
		0.4
	),
	MessageData.new(
		MessageType.OUTGOING,
		"I'm fine. No need to worry about me. This is an emergency line though. Is everything alright?"
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Lookout Bravo, do you copy? Is this an emergency?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Oh, uh... Never mind. It's fine. I can just call back when you're not as busy.",
		0.5
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Not busy. Just want to make sure you're alright. This isn't an emergency then?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Not really. I'm just like, REALLY hungry. That's all.",
		0.5
	),
	MessageData.new(
		MessageType.OUTGOING,
		"You're out of food then? That sounds like an emergency to me."
	),
	MessageData.new(
		MessageType.INCOMING,
		"Well, I'm not exactly OUT of food. I just don't have any to eat, you know?",
		0.5
	),
	MessageData.new(
		MessageType.OUTGOING,
		"I'm not sure I follow. You have food, but you can't eat it?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"I mean, I could eat it, but I can't decide what to cook. I've got a bad case of analysis paralysis.",
		0.5
	),
	MessageData.new(
		MessageType.INCOMING,
		"Sorry. Sorry... I told you it was stupid... I should probably just hang up now...",
		0.4
	),
	MessageData.new(
		MessageType.OUTGOING,
		"No, it's alright. I have time. What ingredients do you have on hand?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Well, I've got some bread... and some peanut butter... and some jelly... and that's it.",
		0.5
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Um... Apologies if I'm stating the obvious, but couldn't you just make a peanut butter and jelly sandwich?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Ugh. That's what EVERYONE has been suggesting, but I've had nothing but PB&J sandwiches for DAYS now.",
		0.5
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Well, perhaps it's time for a trip down the mountain to resupply. Are you a new lookout? Do you need help-"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Don't get me wrong. PB&J is great and all, a classic, as most would agree.",
		0.6
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Lookout Bravo, please try to stay focused. " +
		"We can send someone out your way if you need assistance getting down-"
	),
	MessageData.new(
		MessageType.INCOMING,
		"But at a certain point it stops being a sticky, sweet treat and just feels sticky... You know?",
		0.7
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Lookout Bravo, are you receiving? I think your connection is getting worse."
	),
	MessageData.new(
		MessageType.INCOMING,
		"And ever since I ran out of water last week, it's just been a lot harder to keep the sticky down, ya know?",
		0.75
	),
	MessageData.new(
		MessageType.OUTGOING,
		"You've been without clean water for days now? Why didn't you lead with that?! I'll send someone up to you ASAP."
	),
	MessageData.new(
		MessageType.INCOMING,
		"Hey... I need to get something off my chest. I lied to you...",
		0.75
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Lied? About what?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"I don't really have just the ingredients for PB&J. I've got mayonnaise too.",
		0.75
	),
	MessageData.new(
		MessageType.INCOMING,
		"I should have told you sooner, but I was afraid that if I did, you might suggest a " +
		"peanut butter and mayonnaise sandwich instead.",
		0.75
	),
	MessageData.new(
		MessageType.INCOMING,
		"And I'm afraid of eggs and egg-based products. I'm sorry. Can you forgive me?",
		0.75
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Yes. Fine. Let's just got someone up to help you. Are you in need of anything besides food and water?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Well, since you asked. I am a bit lonely. Maybe you could send up your friendliest ranger with a deck of cards?",
		0.85
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Got it. I think... Your signal is getting even weaker. Is something going on up there?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Oh drat... I was trying to get rid of the mayonnaise before you called, so I smeared it all over the radio antennae.",
		0.9
	),
	MessageData.new(
		MessageType.INCOMING,
		"It looks like the chipmunks finally found it. I'll bet they wouldn't have lied to you. They probably love PB&M...",
		0.9
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Lookout Bravo, I did not call you. You called me, and I have a hard time believing you're not wasting my-"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Pro tip: When the chipmunks are in a feeding frenzy, DO NOT use the acorn-ghillie suit to try and hide from them.",
		0.9
	),
	MessageData.new(
		MessageType.INCOMING,
		"I fear this may be the end for me... Tell my wife... that dinner... is getting... cold...",
		0.9
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Wait a minute... Jim? Is that you?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Guilty as charged, haha! I really had you going this time though, didn't I!",
		0.2
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Yeah, I'll admit it took me a minute to catch on."
	),
	MessageData.new(
		MessageType.INCOMING,
		"Come on home, Christie. You've worked late enough. The kids and I want to see you before the sun goes down for once!",
		0.2
	),
	MessageData.new(
		MessageType.OUTGOING,
		"I suppose you're right... Need to me to pick anything up on the way home?"
	),
	MessageData.new(
		MessageType.INCOMING,
		"Hmm... Maybe some peanut butter... and mayonnaise?",
		0.2
	),
	MessageData.new(
		MessageType.OUTGOING,
		"Not a chance. See you in 10. Ranger station out."
	),
]
var next_message_index: int


# Called when the node enters the scene tree for the first time.
func _ready():
	next_message_index = 0


func get_next_message():

	if next_message_index >= messages.size(): return null

	var message_data = messages[next_message_index]
	var message
	if message_data.type == MessageType.INCOMING:
		message = incoming_message_prefab.instantiate()
		message.init(message_data.text, message_data.missing_letter_rate)
	if message_data.type == MessageType.OUTGOING:
		message = outgoing_message_prefab.instantiate()
		message.init(message_data.text)

	next_message_index += 1
	return message
