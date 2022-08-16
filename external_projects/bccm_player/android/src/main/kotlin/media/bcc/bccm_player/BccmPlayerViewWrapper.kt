package media.bcc.bccm_player

import android.app.Activity
import android.content.Context
import android.content.pm.ActivityInfo
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import androidx.media3.common.*
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.util.DebugTextViewHelper
import androidx.media3.ui.DefaultTimeBar
import androidx.media3.ui.PlayerView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.*


class PlayerPlatformViewFactory(private val activity: Activity, private val playbackService: PlaybackService?) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    @NonNull
    override fun create(@NonNull context: Context?, id: Int, @Nullable args: Any?): PlatformView {
        if (playbackService == null) {
            throw Error("PlaybackService is null, but you tried making a platformview.");
        }

        val creationParams = args as Map<String?, Any?>?
        return BccmPlayerViewWrapper(activity, playbackService, context!!, creationParams?.get("player_id") as String)
    }
}

class BccmPlayerViewWrapper(
        private val activity: Activity,
        private val playbackService: PlaybackService,
        private val context: Context,
        private var playerId: String,
        private val fullscreen: Boolean = false) : PlatformView {
    private var playerController: BccmPlayerController? = null
    private val _v: LinearLayout = LinearLayout(context)
    private var _playerView: PlayerView? = null
    internal var onDispose: () -> Unit = {}

    init {
        setup()
    }

    override fun getView(): View {
        return _v
    }

    override fun dispose() {
        onDispose()
        playerController = null
    }

    fun isFullscreenPlayer(): Boolean {
        return fullscreen
    }

    fun getPlayerView(): PlayerView? {
        return _playerView;
    }

    fun setup() {
        LayoutInflater.from(context).inflate(R.layout.btvplayer_view, _v, true)
        playerController = playbackService.getController(playerId)

        if (playerController == null) {
            throw Error("Player $playerId does not exist. Create it with PlaybackService.newPlayer()")
        }

        val playerView = _v.findViewById<PlayerView>(R.id.brunstad_player)
                .also { _playerView = it };
        val rootLayout: FrameLayout = activity.window.decorView.findViewById<View>(android.R.id.content) as FrameLayout

        playerView.setFullscreenButtonClickListener {
            if (!fullscreen) {
                activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                _v.removeAllViews()
                val fullScreenPlayer = BccmPlayerViewWrapper(activity, playbackService, context, playerId, true)
                rootLayout.addView(fullScreenPlayer.view)
            } else {
                activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
                rootLayout.removeView(view)
                dispose()
            }
        }

        val busyIndicator = _v.findViewById<ProgressBar>(R.id.busyIndicator);
        playerController!!.getExoPlayer().addListener(object : Player.Listener {
            private lateinit var player: Player;
            override fun onEvents(player: Player, events: Player.Events) {
                this.player = player;
            }

            override fun onPlaybackStateChanged(playbackState: Int) {
                setLiveUIEnabled(playerController?.isLive == true)
                playerView.setShowNextButton(false)
                playerView.setShowPreviousButton(false)

                if (playbackState == Player.STATE_READY) {
                    busyIndicator?.visibility = View.GONE;
                }
            }
        })

        val debugTextView = _v.findViewById<TextView>(R.id.debug_text_view);
        val debugHelper = DebugTextViewHelper((playerController!!.getExoPlayer() as ForwardingPlayer).wrappedPlayer as ExoPlayer, debugTextView);
        debugHelper.start();

        playerController!!.takeOwnership(this)
        setLiveUIEnabled(playerController?.isLive == true);
    }

    fun setLiveUIEnabled(enabled: Boolean) {
        val playerView = _v.findViewById<PlayerView>(R.id.brunstad_player) ?: return
        if(playerController?.isLive == true) {
            playerView.setShowFastForwardButton(false)
            playerView.setShowRewindButton(false)
            playerView.setShowMultiWindowTimeBar(false)
            playerView.findViewById<View?>(R.id.exo_progress)?.visibility = View.GONE;
            playerView.findViewById<View?>(R.id.exo_time)?.visibility = View.GONE;
            _v.findViewById<View?>(R.id.live_indicator)?.visibility = View.VISIBLE;
        } else {
            playerView.setShowFastForwardButton(true)
            playerView.setShowRewindButton(true)
            playerView.setShowMultiWindowTimeBar(true)
            playerView.findViewById<View?>(R.id.exo_progress)?.visibility = View.VISIBLE;
            playerView.findViewById<View?>(R.id.exo_time)?.visibility = View.VISIBLE;
            _v.findViewById<View?>(R.id.live_indicator)?.visibility = View.GONE;
        }
    }
}