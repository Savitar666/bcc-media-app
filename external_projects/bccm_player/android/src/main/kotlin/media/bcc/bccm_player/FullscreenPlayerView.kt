package media.bcc.bccm_player

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.pm.ActivityInfo
import android.os.Build
import android.util.Log
import android.util.Rational
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageButton
import android.widget.LinearLayout
import androidx.annotation.RequiresApi
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.media3.common.MediaItem
import androidx.media3.common.Player
import androidx.media3.ui.PlayerView
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.filterIsInstance


class FullscreenPlayerView(val activity: Activity, val playerController: ExoPlayerController) : LinearLayout(activity) {
    var playerView: PlayerView?
    val mainScope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    var isInPip: Boolean = false;
    val orientationBeforeGoingFullscreen = activity.requestedOrientation;
    init {
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED;
        makeActivityFullscreen()
        LayoutInflater.from(context).inflate(R.layout.player_fullscreen_view, this, true)
        playerView = this.findViewById<PlayerView>(R.id.brunstad_player)
        playerView?.let {
            playerController.takeOwnership(it)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val pipButton = findViewById<ImageButton>(R.id.pip_button)
            pipButton.visibility = View.VISIBLE
            pipButton.setOnClickListener {
                enterPictureInPicture()
            }
        }

        // Live ui
        setLiveUIEnabled(playerController.isLive)
        playerController.player.addListener(object : Player.Listener {
            private lateinit var player: Player
            override fun onEvents(player: Player, events: Player.Events) {
                this.player = player
            }

            override fun onIsPlayingChanged(isPlaying: Boolean) {
                playerView?.keepScreenOn = isPlaying
            }

            override fun onMediaItemTransition(mediaItem: MediaItem?, reason: Int) {
                setLiveUIEnabled(playerController.isLive)
            }

            override fun onPlaybackStateChanged(playbackState: Int) {
                setLiveUIEnabled(playerController.isLive)
                val playerView = this@FullscreenPlayerView.playerView;
                playerView?.setShowNextButton(false)
                playerView?.setShowPreviousButton(false)
            }
        })

        mainScope.launch {
            BccmPlayerPluginSingleton.eventBus.filterIsInstance<PictureInPictureModeChangedEvent2>().collect {
                event ->
                isInPip = event.isInPictureInPictureMode
                Log.d("bccm", "PictureInPictureModeChangedEvent2, isInPiP: $isInPip")
                if (!event.isInPictureInPictureMode) {
                    delay(500)
                    makeActivityFullscreen()
                }
            }
        }
        mainScope.launch {
            BccmPlayerPluginSingleton.eventBus.filterIsInstance<OnActivityStop>().collect {
                event ->
                Log.d("bccm", "OnActivityStop and isInPiP: $isInPip")
                playerController.player.stop()
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            mainScope.launch {
                BccmPlayerPluginSingleton.eventBus.filterIsInstance<UserLeaveHintEvent>().collect {
                    event ->
                    Log.d("bccm", "UserLeaveHintEvent and isInPiP: $isInPip")
                        enterPictureInPicture()
                }
            }
        }
    }

    private fun makeActivityFullscreen() {
        WindowCompat.setDecorFitsSystemWindows(activity.window, false)
        WindowInsetsControllerCompat(activity.window, this@FullscreenPlayerView).let { controller ->
            controller.hide(WindowInsetsCompat.Type.systemBars())
            controller.systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        }
    }

    private fun exitFullscreen() {
        WindowCompat.setDecorFitsSystemWindows(activity.window, true)
        WindowInsetsControllerCompat(activity.window, this).show(WindowInsetsCompat.Type.systemBars())
    }

    fun setFullscreenButtonClickListener(listener: () -> Unit) {
        playerView?.setFullscreenButtonClickListener {
            listener()
            activity.requestedOrientation = orientationBeforeGoingFullscreen;
            exitFullscreen()
        }
    }

    fun setLiveUIEnabled(enabled: Boolean) {
        val playerView = playerView ?: return;
        if (enabled) {
            playerView.setShowFastForwardButton(false)
            playerView.setShowRewindButton(false)
            playerView.setShowMultiWindowTimeBar(false)
            playerView.findViewById<View?>(R.id.exo_progress)?.visibility = View.GONE
            playerView.findViewById<View?>(R.id.exo_time)?.visibility = View.GONE
            findViewById<View?>(R.id.live_indicator)?.visibility = View.VISIBLE
        } else {
            playerView.setShowFastForwardButton(true)
            playerView.setShowRewindButton(true)
            playerView.setShowMultiWindowTimeBar(true)
            playerView.findViewById<View?>(R.id.exo_progress)?.visibility = View.VISIBLE
            playerView.findViewById<View?>(R.id.exo_time)?.visibility = View.VISIBLE
            findViewById<View?>(R.id.live_indicator)?.visibility = View.GONE
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun enterPictureInPicture() {
        Log.d("Bccm", "enterPictureInPicture fullscreenplayerView")

        val aspectRatio = playerController.player.let {
            if (it.videoSize.width == 0 || it.videoSize.height == 0) null
            else Rational(it.videoSize.width, it.videoSize.height)
        } ?: Rational(16, 9)

        activity.enterPictureInPictureMode(PictureInPictureParams.Builder()
                .setAspectRatio(aspectRatio)
                .build())
        playerView?.hideController()
    }

    fun release() {
        playerView?.let {
            playerController.releasePlayerView(it)
        }
        mainScope.cancel()
        playerView = null
    }
}