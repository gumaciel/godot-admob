extends Node2D

var admob = null
var instance_id = get_instance_ID() # The instance id from Godot

var is_real = false # Show real ad or test ad
var is_top = true # Show the banner on top or bottom

const AD_BANNER_ID = {
	"Android": "ca-app-pub-3940256099942544/6300978111",
	"iOS"    : "ca-app-pub-3940256099942544/2934735716"
} 
#[Replace with your Ad Unit ID and delete this message]

const AD_INTERSTITIAL_ID = {
	"Android": "ca-app-pub-3940256099942544/1033173712",
	"iOS"    : "ca-app-pub-3940256099942544/4411468910"
}
#[Replace with your Ad Unit ID and delete this message]

const AD_REWARDED_ID = {
	"Android": "ca-app-pub-3940256099942544/5224354917",
	"iOS"    : "ca-app-pub-3940256099942544/1712485313"
}
#[Replace with your Ad Unit ID and delete this message]

var platform_os = OS.get_name()

func _ready():
	if(Globals.has_singleton("AdMob")):
		admob = Globals.get_singleton("AdMob")
		admob.init(is_real, instance_id)
		print("OS: " + platform_os)
		loadBanner()
		loadInterstitial()
		loadRewardedVideo()

		print_debug(get_tree().connect("screen_resized", self, "_on_screen_resized"))

# Loaders
func loadBanner():
	if admob != null:
		admob.loadBanner(AD_BANNER_ID[platform_os], is_top)

func loadInterstitial():
	if admob != null:
		admob.loadInterstitial(AD_INTERSTITIAL_ID[platform_os])
		
func loadRewardedVideo():
	if admob != null:
		admob.loadRewardedVideo(AD_REWARDED_ID[platform_os])

# Events
func _on_BtnBanner_toggled(pressed):
	if admob != null:
		if pressed: admob.showBanner()
		else: admob.hideBanner()

func _on_BtnInterstitial_pressed():
	if admob != null:
		admob.showInterstitial()
		
func _on_BtnRewardedVideo_pressed():
	if admob != null:
		admob.showRewardedVideo()

func _on_admob_network_error():
	print("Network Error")

func _on_admob_ad_loaded():
	print("Ad loaded success")
	if admob != null:
		prints("BannerWidth: " + str(admob.getBannerWidth()), "BannerHeight: " + str(admob.getBannerHeight()))
	get_node("CanvasLayer/BtnBanner").set_disabled(false)

func _on_interstitial_not_loaded():
	print("Error: Interstitial not loaded")

func _on_interstitial_loaded():
	print("Interstitial loaded")
	get_node("CanvasLayer/BtnInterstitial").set_disabled(false)

func _on_interstitial_close():
	print("Interstitial closed")
	get_node("CanvasLayer/BtnInterstitial").set_disabled(true)
	loadInterstitial()

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
	get_node("CanvasLayer/BtnRewardedVideo").set_disabled(false)
	
func _on_rewarded_video_ad_closed():
	print("Rewarded closed")
	get_node("CanvasLayer/BtnRewardedVideo").set_disabled(true)
	loadRewardedVideo()
	
func _on_rewarded(currency, amount):
	print("Reward: " + currency + ", " + str(amount))
	get_node("CanvasLayer/LblRewarded").set_text("Reward: " + currency + ", " + str(amount))


# Resize the banner
func _on_screen_resized():
	if admob != null:
		admob.resize() # this function makes the banner load and show again, but with different size