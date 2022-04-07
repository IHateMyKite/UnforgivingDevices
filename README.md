# UnforgivingDevices
LL link: https://www.loverslab.com/files/file/16938-unforgiving-devices/

This mod is in active development! This means every new version requires new save. Also i don't recommend using this mod for serious playthrough yet. That doesn't mean you can't enjoy this mod but just don't be dissapointed if something get broken.

 
My goal with this mod is to make custom devices with custom behavier. My vision is to convert all devices from framework and give them custom behavier that will be more punishing and realistic for player. With that i mean something along this line: Gas mask will actualy work like gas masks, reducing player ability to breath. Collars can choke player. Moving in restrictive boots will hurt player. Trying to swim with heavy bondage will drown player.

This are all examples of what I want to archieve in this mod (not what is currently in this mod yet).



Custom Restrains

New devices with custom behavier. My main reason for making them was to make escaping restrains less RNG. You will actualy have to invest not small ammout of time to escape them. Many of them have various stats and modifiers, making most devices unique.

(some shortscuts: DPS = Durability per Second, S key = Special key, C key = crit key)

    Following stats are added to all devices
        Durability: Once 0, device gets removed.
        Condition: Every point of reduced durability also reduce condition. After 100 points of condition are reduced, the overal condition get worse (Excellent -> Good -> Normal ...). Reduced condition increase DPS. Once condition get reduced to broken, device gets unlocked.
        Locks: Number of locks which needs to be unlocked before the device is unlocked. Every unlocked lock also increase overall dmg to device-
        Cooldown: Is in minutes and defines how often will device activate itself.
    Following modifiers can be added to devices:
        Sentient: Device can active itself if player tried to remove it. If device activate itself, other equipped device will be active instead.
        Regeneration: Device will slowly regain some of its durability.
        Vibrator: Doesn't do anything. Only tells player that the plug can vibrate. Also shows vib streght.
        Destroy on remove: Device will get destroyed after remove
        Contains loot: Device will drop items when removed (requires Destroy on remove)
        Contains gold: Wearer will receive some gold when the device is removed
        Patched: Means that the device is patched from other mod (see Patches section of description)
        Random manifest: Device have random chance to lock wearer in device/s.
        Orgasm manifest: There is chance that device will lock wearer in device if wearer orgasms.
    There are following escape options:
        Struggling: Player will struggle and slowly lose stats. For every second of struggling some durability is reduced. Once durability reaches zero device will get succesfully escaped. There are following variants:
            Regular struggle: Only drains stamina. Is affectd by Agility attribute
            Desperate struggle: DPS is increased by max health of player. DPS also scales with device health (the less the durability the more the dps). Will drain stamina and health. Is affected by Strength attribute
            Magick struggle: DPS is based on max magicka of player. Deals 150% dmg to condition. Will drain magicka and stamina. Is affeted by Magick attribute.
            Slow struggle: Have very small DPS but also don't drain any stats (they even regenerate at slower rate). This struggle can be also initited at all time, even if player have very small stats.
            To counterpart previous ponts, devices have new variables:
                Physical resistence: Reduce DPS of Regular struggle,Desperate struggle and Slow struggle.
                Magick resistence: Reduce DPS of Magick struggle
        Cutting: Player will have to rapidly press S key to cut device. Once cutted, the device will loose big amount of its condition and also some of its durability.
        Lockpicking: Player can acces the device locks by crit. This will start vannila skyrim lockpick minigame.
        Unlock with key: Player can unlock lock by landing the crit. Crit failure can break the key and jamm the lock.
        Repair lock: This minigame is only avaible if at least one lock is jammed. Every crit will increase progress for repairing the lock. The harder the lock the harder it is to repair.
    In some minigames, crits can occur. This will cause either the magicka meter or stamina meter to blink. If player fastly press correct C key (Default: A for M meter, D for S meter), something will happen. In struggle minigame, more durability will be reduced, in cutting minigame more progress will be added. In lock reaching minigame, pressing correct C key give much bigger chance of reaching the lock. Also every device can have differect crit multiplier which changes how effetient the crit is. But they can also have different chance of the crit occuring. So some device may have very small chance of crit happening but will have big multiplier, making the crit more rewarding.
    Some minigames require player to press S key to progress (like removing the plug or cutting the minigame)
    Some minigames are affected by new attributes. Every attribute is made from various normal skyrim skills.
        Agility: Made from Pickpocket skill
            Affects Regular struggle
        Strength: Made from 2h skill
            Affects Desperate struggle
        Magick: Made from Destruction skill
            Affects Magick struggle
        Example: If player have 2h skill = 15, Destruction  = 15 and Pickpocket = 25 -> Agility = 25, Strength = 15, Magick = 15
        Every point of attribute increase corresponding minigame effectiveness by 1% (1.5% for Regular struggle)
        This value can be seen in wearer detail option of device detail menu
    Following devices types were changed
        Plugs: They can be struggle from as long as player doesn't have belt or harness. But having tied hands,wearing hobble dress or bondage suit will reduce effectiveness of this method. Sentient plugs have chance of turning themself on. Instead of normal struggle minigames, player have to force out the minigame. This is done by rapidly pressing the S key.
        Inflatable plugs: Can be inflated/deflated. In case of player having tied arms, they can still try to manipulate the plug, but it requires to struggle. Also the more the plug is inflated, the harder it is to remove it. Sentient modifiers adds chance of this plugs inflating themselfs.
        Piercings: Can only be escaped by unlocking with key or lockpicking. Nipple piercing also have active event which will lock random device on player. Nothing special
        Panel gags: Their plug can be removed/added all time. Having tied hands will start minigame in which player needs to remove the plug. Sentient mod gives this gag ability to insert the plug back if it was removed.
        Mittens: Struggling with mittens is less effective
        Inflatable gag: WIP
    Following device types were created
        Controlable plug: Plug which can be turned on and off. Once turned on, the plug will slowly discharg itself (stronger vibs will discharg plug faster). Plug can be also turned off with tied hands, but player will need to complete minigame. Sentient mod adds chance of plug turning itself on with random vib strength.
        Abadon plug: More info down in description

     Also, in case you are using DD Cursed Loot, you have to disable Device buffs and Horny buffs, which for some reason kill player when they reach small HP. Guide in spoiler below
      Reveal hidden contents

 

Patches

Patches adds this mod behavier to devices from other mods. This devices stats are set automatically with some randomness. If you think some of this devices are too hard or easy, let me know and i will rebalance it. Every patch needs to be loaded after mod that it patches!

There are following patches which are included in current mod version (selectable in FOMOD installer)

    DD Patchs: Patches DDA,DDI and DDE. Patches around 98% of all devices. Only ones that are not done yet, and I know abou, are link gloves.
        BRRF patch: Needs to be loaded after BRRF.
        BRRF + For Him:  Needs to be loaded after BRRF and For Him. Also BRRF needs to be after For Him.
    DCL Patch: The number of patched devices is lower because there are many devices with custom scripts. Also don't forget to disable Device and Horny buff as mentioned above
        Requires Deviously Cursed Loot 9.0 by @Kimy
    Devious Pink Patch: Patches all devices
        Requires Devious Pink by @naaitsab
    Rubber Facility patch: Patches most devices, but because bunch of them can't be accesed in game directly, you will have to use additemmenu or other mods
        Requires Rubber Facility by @Prime66 & @Racoonity, Serah

Abadon Plug
Plug that is locked on player and grow stronger over time. To get this quest you will need to complete quest Dragon Rising (quest where you kill dragon at tower in front of whiterun). After that you should get letter from courier which will start the quest. If you just wan't to jump directly to action you can eaither complete Dragon rising quest by entering "help MQ104" and then "completequest <id which you got for MQ104>". If you don!t want to break game you can also type "help UD_AbadonQuest" and then "completestage <Abadon Curse quest id> 10". This will send the courier. This quest is still in making so there is not much to it. It just works as natural way for obtaining this plug. Later i will work more on bad ending so it actually have some kind of story.

(!curently in beta!) Custom vibrations/orgasm (!curently in beta!)

    Adds new system to manage actor orgasm. This system works in following way. Actor have new varible called Orgam Rate (ORAT) which defines how fast will actor orgasm (or if actor will be edged).
    If actor arousal reaches certain threshold (90 now), will start to reach the orgasm. If actor is player, widget will be shown above the device widget (Shows when orgasm progress is more then 5%). On every second, actor orgasm progress (OP) will increase by ORAT, but also gets reduced by small value, which is defined by Orgasm resistence (ORES). This negative value is called Anti Orgasm Rate (AORAT), and its bigger the more the actor is close to orgasm, topping at 100% where AORAT = ORES. Because of that, for actor to be able to reach orgasm, ORAT needs to be atleast little bigger then ORES. Otherwise, OP will stop somewhere before 100% -> actor is edged. If progress reaches 100%, actor orgasms, and normal DD orgasm event is called.
    Also reworked how vibration function work to make this work
        New script UD_CustomVibratorBase_RenderScript which is base of every device which can vibrate is added.
        Vibrate function is much simpler then the one in DD. It mostly only increase actor arousal and applies ORAT
        This means that every device can vibrate on its own. So one device can start to vibrate, the other and one of them can stop before the otehr etc..
    Player can start orgasm resisting minigame by pressing new Player Menu Key.
    This minigame is very simple for now and only plays animation while reducing palyer stamina.
    While the minigame is on, ORAT is reduced to 0, but AORAT is still used, so progress will reduce slowly. Once minigame ends, this effect will also stop
    The more the ORAT, the more stamina will be sapped for second of minigame.
    Only relevant in version > 2.0b3
        AORAT also changes with increasing arousal. AORAT reaches its minimum when actor arousal is 100. This is exponencial, and function for this looks like this:
            AORAT = fRange((Math.pow(10,fRange(100.0/Arousal,1.0,2.0) - 1.0)),1.0,100.0)*ORESM*(OP*(ORES/100.0))
              Reveal hidden contents

             
        Actor can now also reach orgasm no matter what arousal they have
        Added minigame crits, which are set at constant 15%.
            Striking crit will restore some stamina and also reduce orgasm progress.
            Failing the crit will do the opposite
        Mechanic with Special button. Minigame widget will randomly change color. Holding the S button while color is changed will result in different effects.
            Red: Reduce stamina consumption by 75%
            Green: Reduces orgasm progress. Also reduces stamina consumption by 25%.
            Blue: Reduces arousal. Also reduces stamina consumption by 25%.
        Effects are active for as long as the button is pressed and the color is changed.
        If the button is pressed while color is normal (pink), stamina consumption will increase by 100%.
        Duration of how long will be color changed is random, so sometimes its better to stop pressing the S button befor it changes to normal color and starts draining more stamina

 

Other functionality

    Orgasm exhaustion: When player orgasm, exhaustion debuff is applied for set period of time. This debuff decrease player stamina/magicka regeneration. Player will also be unable to wait. Works with any DD/SL induced orgasm (aka you don't need any special device, any plug by framework/other mods will have this effect, as long the orgasm event is sent). Can be toggle/modified in mcm.
        Only relevant in version > 2.0b2
            Reduces Orgasm Rate multiplier
            Arousal created by vibrations is also reduced
    Heavy bondage swimming: Swimming with tied hands is very hard. Player will starts loosing stamina and have movement speed reduced by big amount. Once stamina runs out, player will start to drown. While drowning, player will be slowed even further and starts to also loose health. This can kill player (obviously) so if you don't like it you can turn it off in mcm. There are also 3 difficulties to choose from if it is too hard/easy for you. From balance perspective: if you drop down in middle of lake, you will for 100% die. Crossing small rivers should be ok if there is not strong stream. Waterbreathing will prevent player from loosing health when drowning (but slow will be still applied).

 

You can't currently get any most of this devices in the game by natural means. You will have to either use console or AddItemMenu.

For abadon plug you can alternatively use my mod Alternate start - More Devious Starts that will give you option of starting game with this plug.

 

NPC support

Any of this devices Abadon plug wont work with NPCs so don't try to quip it on them. This devices are supposed to be more script heavy and making them to also work for NPCs would propably make your PC explode. I even added some simple safe check that should prevent player from equiping it on NPCs. Devices will work mostly like normal devices excapt for abadon plug which should never be used on npc. Devices will work but they will lose their custom behavior.

As of version 1.16, npcs are supported. This means you can lock any device on npc and it should work. The system and how it works is little too complicated so i will try to explain at least the how it fundamentaly works.

    There are 10 npc slots. All of this slots are automatically (by default) scaned in 4s inteval. Only npcs which wear Unforging device and are alive will be registered.
    All registered npcs are periodically updated like player. This means even npcs devices can regen, activate their effect and other things thet depends on update function.
    Every registered npc have also slots for devices. If npcs have device locked on them, this device will get registered. Theese devices can be accesed in MCM debug menu.
    If npc is NOT registered, the devices can still be accesed using new function which fetch the device by transefering it between storages. This makes the device flicker.

Every device can be accesed with container menu. Best way to try this is follower because it alows player to acces its inventory from start. Other npcs starege can be accessed by either sneaking or if player have free hands and npcs doesn't (if npcs can, why we can't ?).

Player can also help npcs to struggle. This will start new minigame with boosted stats. Player can also get help from other npcs this way (just click on desaired device while having container menu opened with npc).

There are also new device menu options

    Tighten up: Increase device durability by ~10
    Repair: Increase device condition by ~23
    Command: Only avaible for followers. Allow player to command npcs what should npc do. This way player can force npc to star solo minigame. If player want to force npc to stop the minigame, they have to choose dialogue option [STOP MINIGAME].

Lastly, there is mcm option to dissable automatic slot scan. In case of disabling this, most features should still be avaible. Only thing that will not work is that devices will not get updated. Also player can force scan manually using mcm debug menu. Undesired slots can also be removed this way.

NPCs are not currently tested with beta vibration function

 

Default Key Bindings
  Reveal hidden contents

 

 

Current issues

    Bad compatibility with Devious Lore
    Mod is very script heavy. Weaker computers may have issues.
    Balance

 

Special edition

After trying it i thing it works with se just fine. If you want to use it in SE just download file and install it like SE mod. If you use MO it will probably give you warning of using older form. Just ignore it (most of the dd mods for SE use older form anyway). I didnt have enough time to try every thing. So if you use this mod with SE (or with LE) and you find something not working or ode please let me know.

 

Future plans

    Complete custom devices for all possible kind of restrains
    Making more Custom Heavy bondage devices so there is more variaty Maybe in different mode
    Custom vib function which will be more compatible with my mod Done?
    More devices with custom behavier. My next possible target will propably be collar that throttle player as suggested by SirCrazy

 

Credits to

    SirCrazy for suggesting how the intro quest for plug should look and writting some of the text in the quest.
    @S.MayLeR for making russian translation
    @naaitsab for contributing sentient dialogues and also explaining how to implement it
    @Shakx88 for creating Devices Escape Overhaul which was main inspiration when creating this mod
    Everyone who has taken part in creating DD framework
    Everyone who have given feedback/ideas for this mod

 

Troubleshooting

In case you found that something is not working or not working as intended, please report it in support thread and i will give it a look. But also please add following information to your report

    Version of skyrim: LE/SE
    Version of mod (in case of using older version then current)
    Used patches (if none, then also type it)
    In case that some device doesn't work but other works, tell me exactly which device doesn't work, not just type (saying that one boots does't work will really not help me)
    (Optional) Papyrus log. If you don't know what it is then you don't need to worry. I just need it if things get really broken. In most cases I manage to replicate the bug so this isn't really required.
