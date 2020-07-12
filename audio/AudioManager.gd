extends Node

const MUTE_DB = -40
const REGULAR_DB = -6
const FADEIN_SPEED = 40
const FADEOUT_SPEED = 20

const BGMS = {
	"gameplay1": preload("res://assets/sound/bgm/gameplay_layer1.ogg"),
	"gameplay2": preload("res://assets/sound/bgm/gameplay_layer2.ogg"),
	"boss1": preload("res://assets/sound/bgm/boss_layer1.ogg"),
	"boss2": preload("res://assets/sound/bgm/boss_layer2.ogg"),
	"ending": preload("res://assets/sound/bgm/ending.ogg"),
	"intro": preload("res://assets/sound/bgm/intro.ogg"),
	"heartbeat": preload("res://assets/sound/bgm/heartbeat.ogg"),
}


func play_bgm(name, tracks):
	stop_bgm()
	if tracks == 1:
		var player = $TrackFadeIn1
		player.stream = BGMS[name]
		fadein(player)
	else:
		$TrackFadeIn1.stream = BGMS[name+str(1)]
		$TrackFadeIn2.stream = BGMS[name+str(2)]
		fadein($TrackFadeIn1)
		fadein($TrackFadeIn2)

func fadein(player, boost = 0):
		player.volume_db = MUTE_DB
		player.play()
		$Tween.interpolate_property(player, "volume_db", MUTE_DB, REGULAR_DB + boost,
									abs(MUTE_DB - REGULAR_DB - boost)/FADEIN_SPEED,
									Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

func fadeout(player):
		$Tween.interpolate_property(player, "volume_db", player.volume_db,
									MUTE_DB, abs(MUTE_DB - player.volume_db)/FADEOUT_SPEED,
									Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

func update_tracks(number):
	if number == 2:
		if not $TrackFadeIn1.playing:
			fadein($TrackFadeIn1)
		if not $TrackFadeIn2.playing:
			fadein($TrackFadeIn2)
	elif number == 1:
		if not $TrackFadeIn1.playing:
			fadein($TrackFadeIn1)
		if $TrackFadeIn2.playing:
			fadeout($TrackFadeIn2)
	elif number == 0:
		if $TrackFadeIn1.playing:
			fadeout($TrackFadeIn1)
		if $TrackFadeIn2.playing:
			fadeout($TrackFadeIn2)
			
func stop_bgm():
	if $TrackFadeIn1.playing:
		var fadein = $TrackFadeIn1
		var fadeout = $TrackFadeOut1
		var pos = fadein.get_playback_position()
		fadein.stop()
		fadeout.volume_db = fadein.volume_db
		fadeout.stream = fadein.stream
		fadeout.play(pos)
	if $TrackFadeIn2.playing:
		var fadein = $TrackFadeIn2
		var fadeout = $TrackFadeOut2
		var pos = fadein.get_playback_position()
		fadein.stop()
		fadeout.volume_db = fadein.volume_db
		fadeout.stream = fadein.stream
		fadeout.play(pos)

func play_heartbeat():
	if not $HeartBeat.playing:
		var player = $HeartBeat
		fadein(player, 10)

func stop_heartbeat():
	if $HeartBeat.playing:
		var player = $HeartBeat
		fadeout(player)
