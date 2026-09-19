package states;

import states.PlayState;

// This probably will not get finished for a little while sadly.
class ResultsScreen extends MusicBeatState
{
    var characters:String = 'AaBbCcDdEeFfGgHhiIJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz:1234567890';

    var bg:FlxSprite;
    var soundSystem:FlxSprite;
    var heartsPerfect:FlxAnimate = null;
    var percent:Float = 0.0;
    var newHi:Bool = false;
    var game:PlayState = null;
    var resultsBf:FlxAnimate = null;
    var resultsGf:FlxAnimate = null;

    override function create()
    {
        #if DISCORD_ALLOWED
        DiscordClient.changePresence("Seeing Their Results", null);
        #end

        game = PlayState.instance;

        if (PlayState.isStoryMode)
        {
            newHi = (PlayState.campaignScore > Highscore.getWeekScore(
                WeekData.getWeekFileName(),
                PlayState.storyDifficulty
            ));
        }
        else
        {
            newHi = (game.songScore > Highscore.getScore(
                PlayState.SONG.song,
                PlayState.storyDifficulty
            ));
        }

        if (game.vocals != null)
            game.vocals.volume = 0;

        if (game.opponentVocals != null)
            game.opponentVocals.volume = 0;

        bg = new FlxSprite().makeGraphic(1, 1, -1);
        bg.color = 0xfffec85c;
        bg.scale.set(FlxG.width, FlxG.height);
        bg.updateHitbox();

        var bgFlash:FlxSprite = FlxGradient.createGradientFlxSprite(
            1,
            FlxG.height,
            [0xfffff1a6, 0xfffff1be],
            90
        );

        bgFlash.scale.set(1280, 1);
        bgFlash.updateHitbox();
        bgFlash.scrollFactor.set();

        var bgTop:FlxSprite = new FlxSprite().makeGraphic(1, 1, -1);
        bgTop.color = 0xfffec85c;
        bgTop.scale.set(535, FlxG.height);
        bgTop.updateHitbox();

        var cats:FlxSprite = new FlxSprite(-135, 135);
        cats.frames = Paths.getSparrowAtlas(
            'results_screen/ratingsPopin',
            'base_game/shared'
        );
        cats.animation.addByPrefix('main', 'Categories', 24, false);
        cats.antialiasing = ClientPrefs.data.antialiasing;

        var score:FlxSprite = new FlxSprite(-180, FlxG.height - 205);
        score.frames = Paths.getSparrowAtlas(
            'results_screen/scorePopin',
            'base_game/shared'
        );
        score.animation.addByPrefix('main', 'tally score', 24, false);
        score.antialiasing = ClientPrefs.data.antialiasing;

        var misses:Int = PlayState.isStoryMode
            ? PlayState.campaignMisses
            : game.songMisses;

        var hits:Int = game.ratingsData[0].hits + game.ratingsData[1].hits;
        var breaks:Int = game.ratingsData[2].hits + game.ratingsData[3].hits + misses;

        var clearStatus:Int = Math.floor(
            hits / Math.max(hits + breaks, 1) * 100
        );

        var rank:String = findRank(clearStatus);

        var bf:FlxAnimate = null;
        var gf:FlxAnimate = null;

        switch (rank)
        {
            case 'PERFECT':
                bf = new FlxAnimate(1342, 370);

                Paths.loadAnimateAtlas(
                    bf,
                    'results_screen/characterResults/bf/resultsPERFECT',
                    'base_game/shared'
                );

                bf.anim.onComplete = () ->
                {
                    if (bf != null)
                    {
                        bf.anim.curFrame = 137;
                        bf.anim.play();
                    }
                };

                heartsPerfect = new FlxAnimate(1342, 370);

                Paths.loadAnimateAtlas(
                    heartsPerfect,
                    'results_screen/characterResults/bf/resultsPERFECT/hearts',
                    'base_game/shared'
                );

                heartsPerfect.anim.onComplete = () ->
                {
                    heartsPerfect.anim.curFrame = 43;
                    heartsPerfect.anim.play();
                };

                heartsPerfect.antialiasing = ClientPrefs.data.antialiasing;
                heartsPerfect.scrollFactor.set();
                heartsPerfect.alpha = .0001;

            case 'EXCELLENT':
                bf = new FlxAnimate(1329, 429);

                Paths.loadAnimateAtlas(
                    bf,
                    'results_screen/characterResults/bf/resultsEXCELLENT',
                    'base_game/shared'
                );

                bf.anim.onComplete = () ->
                {
                    if (bf != null)
                    {
                        bf.anim.curFrame = 28;
                        bf.anim.play();
                    }
                };

            case 'GREAT':
                bf = new FlxAnimate(929, 363);

                Paths.loadAnimateAtlas(
                    bf,
                    'results_screen/characterResults/bf/resultsGREAT/bf',
                    'base_game/shared'
                );

                bf.scale.set(.93, .93);

                bf.anim.onComplete = () ->
                {
                    if (bf != null)
                    {
                        bf.anim.curFrame = 15;
                        bf.anim.play();
                    }
                };

                gf = new FlxAnimate(802, 331);

                Paths.loadAnimateAtlas(
                    gf,
                    'results_screen/characterResults/bf/resultsGREAT/gf',
                    'base_game/shared'
                );

                gf.scale.set(.93, .93);

                gf.anim.onComplete = () ->
                {
                    if (gf != null)
                    {
                        gf.anim.curFrame = 9;
                        gf.anim.play();
                    }
                };

            case 'SHIT':
                bf = new FlxAnimate(0, 20);

                Paths.loadAnimateAtlas(
                    bf,
                    'results_screen/characterResults/bf/resultsSHIT',
                    'base_game/shared'
                );

                bf.anim.addBySymbol('intro', 'Intro', 24, true, 0, 0);
                bf.anim.addBySymbol('loop', 'Loop Start', 24, true, 0, 0);

                bf.anim.onComplete = () ->
                {
                    if (bf != null)
                    {
                        bf.anim.curFrame = 149;
                        bf.anim.play();
                    }
                };

            default:
                bf = new FlxSprite(640, -200);

                bf.frames = Paths.getSparrowAtlas(
                    'results_screen/resultBoyfriendGOOD',
                    'base_game/shared'
                );

                bf.animation.addByPrefix(
                    'start',
                    'Boyfriend Good Anim',
                    24,
                    false
                );

                bf.animation.addByIndices(
                    'loop',
                    'Boyfriend Good Anim',
                    [70, 71, 72, 73],
                    '',
                    24,
                    true
                );

                bf.antialiasing = ClientPrefs.data.antialiasing;

                bf.animation.finishCallback = () ->
                {
                    if (bf != null)
                        bf.animation.play('loop');
                };

                gf = new FlxSprite(625, 325);

                gf.frames = Paths.getSparrowAtlas(
                    'results_screen/resultGirlfriendGOOD',
                    'base_game/shared'
                );

                gf.animation.addByPrefix(
                    'start',
                    'Girlfriend Good Anim',
                    24,
                    false
                );

                gf.animation.addByIndices(
                    'loop',
                    'Girlfriend Good Anim',
                    [46, 47, 48, 49, 50, 51],
                    '',
                    24,
                    true
                );

                gf.animation.play('start');
        }

        if (bf != null)
        {
            bf.scrollFactor.set();
            bf.antialiasing = ClientPrefs.data.antialiasing;
            bf.alpha = .0001;
            resultsBf = bf;
        }

        if (gf != null)
        {
            gf.scrollFactor.set();
            gf.antialiasing = ClientPrefs.data.antialiasing;
            gf.alpha = .0001;
            resultsGf = gf;
        }
    }

    function findRank(percent:Float):String
    {
        if (percent >= 100)
            return 'PERFECT';

        if (percent >= 90)
            return 'EXCELLENT';

        if (percent >= 80)
            return 'GREAT';

        if (percent >= 60)
            return 'GOOD';

        return 'SHIT';
    }
}
