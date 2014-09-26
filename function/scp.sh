#!/bin/bash
scp_(){
scp_$1 $@ #todo
}
scp_getPlugin(){
local name=$1
local version=$2
#if [ "$2" != "" ];then

#fi;
msg_$FUNCNAME $name;
mkdir -p $thisServerPath/plugins/$name
scp_getPlugin_jar $name $version
scp_getPlugin_$name $@
}
scp_getPlugin_whole(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp_getPlugin_jar $name
scp $from $thisServerPath/plugins
}
scp_getPlugin_jar(){
local name=$1
local version=$2
local from=$syncServerScpPath/plugins
local to=$thisServerPath/plugins
if [ "$2" == "" ];then
scp $from/$name.jar $to/$name.jar
else
scp $from/$version/$name.jar $to/$name.jar
fi;
}
scp_getWorld(){
local name=$1
scp_getWorld_$name $@
}
scp_getWorld_region_0_0_spawn(){
local name=$1
local f="r.0.0.mca"
local from=$syncServerScpPath/world/region/$name
local to=$thisServerPath/$thisWorldName/region
scp $from/$f $to/$f
}
scp_getServer(){
local name=$1
scp_getServer_$name $@
}
scp_getServer_jar(){
local f=$1
scp $syncServerScpPath/$f $thisServerPath/$f
}
scp_getServer_icon(){
local from=$syncServerScpPath/server-icon.png
local to=$thisServerPath/server-icon.png
scp $from $to
}
scp_getServer_vanilla(){
local jar="minecraft_server.jar"
scp_getServer_jar $jar
scp_getVanillaConf
fix_start_jar $jar
}
scp_getVanillaConf(){
local files=(
server.properties
eula.txt
#usercache.json
ops.json
whitelist.json
banned-ips.json
banned-players.json
#ops.txt
#white-list.txt
#banned-ips.txt
#banned-players.txt
)
for f in ${files[@]};do
scp $syncServerScpPath/${f} $thisServerPath/${f}
done
}
scp_getServer_spigot(){
local jar="spigot.jar"
scp_getServer_jar $jar
scp_getSpigotConf
scp_getBukkitConf
scp_getVanillaConf
if [ ! -d "$thisServerPath/plugins" ];then
mkdir -p $thisServerPath/plugins
fi
fix_start_jar $jar
}
scp_getSpigotConf(){
local f=spigot.yml
scp $syncServerScpPath/$f $thisServerPath/$f
}
scp_getServer_bukkit(){
local jar="craftbukkit.jar"
scp_getServer_jar $jar
scp_getBukkitConf
scp_getVanillaConf
if [ ! -d "$thisServerPath/plugins" ];then
mkdir -p $thisServerPath/plugins
fi
fix_start_jar $jar
}
scp_getBukkitConf(){
local files=(
bukkit.yml
commands.yml
)
for f in ${files[@]};do
scp $syncServerScpPath/$f $thisServerPath/$f
done
}
scp_getServer_proxy(){
local jar="BungeeCord.jar"
scp_getServer_jar $jar
scp_getConf_proxy
if [ ! -d "$thisServerPath/plugins" ];then
mkdir -p $thisServerPath/plugins
fi
fix_start_jar $jar
}
scp_getConf_proxy(){
local from=$syncServerScpPath/BungeeCord.config.yml
local to=$thisServerPath/config.yml
scp $from $to
}
scp_getController(){
scp_getControllers;
}
scp_getControllers(){
local files=(
run.sh
start.sh
restart.sh
logs.sh
)
echo "getController need before getServer!"
for f in ${files[@]};do
scp $syncServerScpPath/${f} $thisServerPath/${f}
done
#scp_getController_gc_on
}
scp_getController_gc_on(){
local to=$thisServerPath/start.sh
#開啟gc顯示
sed -i '/argArray=(/a \-verbosegc' $to
sed -i '/argArray=(/a \-Xloggc:gc.log' $to
to=$thisServerPath/gc.log
echo 'Restarted' >> $to
echo `date +"%F %T"` >> $to
cat $to >> $to.0
}
scp_getPlugin_BungeeSuite(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
local files=(
announcements.yml
config.yml
bans.yml
chat.yml
Messages.yml
)
local f
for f in ${files[@]};do
scp $from/$f $to
done
}
scp_getPlugin_WorldEdit(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to/config.yml
scp -r $from/schematics $to
scp $from/$thisServerName.config.yml $to

if [ -f $to/$thisServerName.config.yml ];then
  mv $to/$thisServerName.config.yml $to/config.yml
fi

local dname="logs"
mkdir -p $thisServerPath/plugins_backup/$name/$dname
ln -s ../../plugins_backup/$name/$dname $to/$dname
}
scp_getPlugin_EpicBossRecoded(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
local files=(
Bosses.yml
Options.yml
download.sh
upload.sh
)
for f in ${files[@]};do
scp $from/$f $to/$f
done
scp -r $from/$thisServerName $to
scp_getPlugin_EpicBossRecoded_restore $name
}
scp_getPlugin_EpicBossRecoded_restore(){
local name=$1
local from=$thisServerPath/plugins/$name/$thisServerName
local to=$thisServerPath/plugins/$name
mv $from/* $to
}
scp_getPlugin_EpicBossGoldEdition(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
local files=(
#Bosses.yml
#Options.yml
#download.sh
#upload.sh
)
for f in ${files[@]};do
scp $from/$f $to/$f
done
scp -r $from/$thisServerName $to
#scp_getPlugin_EpicBossGoldEdition_restore $name
}
scp_getPlugin_EpicBossGoldEdition_restore(){
local name=$1
local from=$thisServerPath/plugins/$name/$thisServerName
local to=$thisServerPath/plugins/$name
mv $from/* $to
}
scp_getPlugin_MythicMobs(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
local files=(
#Bosses.yml
)
#for f in ${files[@]};do
#scp $from/$f $to/$f
#done
scp -r $from $to/../

local dname="SavedData"
mkdir -p $thisServerPath/plugins_backup/$name/$dname
ln -s ../../plugins_backup/$name/$dname $to/$dname
local dname="Spawners"
mkdir -p $thisServerPath/plugins_backup/$name/$dname
ln -s ../../plugins_backup/$name/$dname $to/$dname
}
scp_getPlugin_VariableTriggers(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to
scp $from/*.script.yml $to
scp $from/*.sh $to
scp -r $from/$thisServerName $to
scp_getPlugin_VariableTriggers_restore $name
}
scp_getPlugin_VariableTriggers_restore(){
local name=$1
local from=$thisServerPath/plugins_backup/$name
local to=$thisServerPath/plugins/$name
if [ -d $to/$thisServerName ];then
mv $to/$thisServerName/* $to
fi
}
scp_getPlugin_BungeeSuite_all(){
scp_getPlugin BungeeSuiteBans;
scp_getPlugin BungeeSuitePortals;
scp_getPlugin BungeeSuiteSpawn;
scp_getPlugin BungeeSuiteTeleports;
scp_getPlugin BungeeSuiteWarps;
}
scp_getPlugin_BungeeSuiteBans(){
local name=$1
}
scp_getPlugin_BungeeSuitePortals(){
local name=$1
}
function scp_getPlugin_BungeeSuiteSpawn(){
#會造成teleport牌子無法顯示！
local name=$1
}
scp_getPlugin_BungeeSuiteTeleports(){
local name=$1
}
scp_getPlugin_BungeeSuiteWarps(){
local name=$1
}
scp_getPlugin_TeleportSigns(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to/config.yml
scp $from/upload.sh $to/upload.sh
scp $from/$thisServerName.db $to/$name.db #restoreDb
}
scp_getPlugin_ColoredSigns(){
local name=$1
}
scp_getPlugin_ChatColors(){
local name=$1
}
scp_getPlugin_ColoredTexts(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to/config.yml
}
scp_getPlugin_PermissionsEx(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to/config.yml
#sed -ri "s/(      uri: mysql:\/\/)10.0.0.200(\/PermissionsEx)/\1localhost\2/g" PermissionsEx/config.yml
}
scp_getPlugin_Vault(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to/config.yml
}
scp_getPlugin_iConomy(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/Config.yml $to
scp $from/Template.yml $to
scp -r $syncServerScpPath/lib $thisServerPath
}
scp_getPlugin_WorldBorder(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to/config.yml
}
scp_getPlugin_IslandWorld(){ #must need world edit
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/*.sh $to
scp $from/*.yml $to
scp $from/*.xml $to
scp -r $from/schematics $to
scp -r $from/$thisServerName $to
scp_getPlugin_IslandWorld_restore $name
}
scp_getPlugin_IslandWorld_restore(){
local name=$1
local d=backup
local from=$thisServerPath/plugins_backup/$name
local to=$thisServerPath/plugins/$name
if [ ! -d $from/$d ];then
mkdir -p $thisServerPath/plugins_backup
mkdir -p $from
mkdir -p $from/$d
fi
ln -s $from/$d $to/$d
mv $to/$thisServerName/islelistV6.dat $to
mv $to/$thisServerName/freelistV6.dat $to
mv $to/$thisServerName/compChallenges.dat $to
}
scp_getPlugin_Essentials(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
local files=(
config.yml
motd.txt
rules.txt
info.txt
book.txt
#worth.yml use default
#spawn.yml: every server's spawn point is different!
#userdata/: homes and logout location
#warp/: warp location, replaced by bungeesuite warp
)
for f in ${files[@]};do
scp $from/$f $to
done
scp $from/*.sh $to
scp_getPlugin_Essentials_restore $name
}
scp_getPlugin_Essentials_restore(){
local name=$1
local f=jail.yml
local d=userdata
local from=$thisServerPath/plugins_backup/$name
local to=$thisServerPath/plugins/$name
if [ -f $from/$f ];then
mv $from/$f $to
fi
if [ ! -d $from/$d ];then
mkdir -p $from/$d
fi
ln -s $from/$d $to/$d
}
scp_getPlugin_EssentialsSpawn(){
local name=$1
}
scp_getPlugin_mcMMO(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to
scp $from/*.sh $to
scp_getPlugin_mcMMO_restore $name
}
scp_getPlugin_mcMMO_restore(){
local name=$1
local ds=(
flatfile
backup
)
local d
local from=$thisServerPath/plugins_backup/$name
local to=$thisServerPath/plugins/$name
if [ ! -d $from/${ds[0]} ] || [ ! -d $from/${ds[1]} ] ;then
mkdir -p $thisServerPath/plugins_backup
mkdir -p $from
for d in ${ds[@]};do
mkdir -p $from/$d
done
fi
for d in ${ds[@]};do
ln -s $from/$d $to/$d
done
}
scp_getPlugin_MobBountyReloaded(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp -r $from $to/..
}
scp_getPlugin_HealthBar(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp -r $from $to/..
}
scp_getPlugin_AutoSaveWorld(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp -r $from $to/..
}
scp_getPlugin_AuthMe(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp -r $from $to/..
}
scp_getPlugin_PlotMe(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/caption-zh_TW.yml $to
scp $from/*.sh $to
scp_getPlugin_PlotMe_restore $name
}
scp_getPlugin_PlotMe_restore(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/$thisServerName.config.yml $to/config.yml
}
scp_getPlugin_DeathMessages(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to/config.yml
}
scp_getPlugin_CoreProtect(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/$thisServerName.config.yml $to/config.yml
}
scp_getPlugin_dynmap(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/configuration.txt $to/configuration.txt
#webserver-port: 8123
scp_getPlugin_dynmap_restore $name
}
scp_getPlugin_dynmap_restore(){
local name=$1
local d=tiles
local from=$thisServerPath/plugins_backup/$name/web
local to=$thisServerPath/plugins/$name/web
if [ ! -d $from/$d ];then
mkdir -p $thisServerPath/plugins_backup
mkdir -p $thisServerPath/plugins_backup/$name
mkdir -p $from
mkdir -p $from/$d
fi
mkdir -p $to
ln -s $from/$d $to/$d
}
scp_getPlugin_DynmapPlotMe(){
local name=$1
}
scp_getPlugin_Dynmap-Essentials(){
local name=$1
}
scp_getPlugin_dynmap-residence(){
local name=$1
}
scp_getPlugin_Lockette(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp -r $from $to/..
}
scp_getPlugin_BringBackTheEnd(){
local name=$1
local f=config.yml
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/$f $to
sed -i "s/\  worldName:.*$/\  worldName: $thisWorldNameTheEnd/g" $to/$f
}
scp_getPlugin_Residence(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to/config.yml
scp -r $from/Language $to
scp $from/*.sh $to
scp_getPlugin_Residence_restore $name
}
scp_getPlugin_Residence_restore(){
local name=$1
local ds=(
Backup
Save
)
local from=$thisServerPath/plugins_backup/$name
local to=$thisServerPath/plugins/$name
if [ ! -d $from/${ds[0]} ] || [ ! -d $from/${ds[1]} ];then
mkdir -p $thisServerPath/plugins_backup
mkdir -p $from
for d in ${ds[@]};do
mkdir -p $from/$d
done
fi
for d in ${ds[@]};do
ln -s $from/$d $to/$d
done
}
scp_getPlugin_MultiWorld(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/$thisServerName.config.yml $to/config.yml
scp $from/*.sh $to
}
scp_getPlugin_GriefPrevention(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
}
scp_getPlugin_KillerMoney(){ #need vault and Economy plugin
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to/config.yml
scp $from/zh_TW_messages.yml $to/zh_TW_messages.yml
scp $from/version.yml $to/version.yml
}
scp_getPlugin_Quicksand(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/$thisServerName.config.yml $to/config.yml
scp $from/upload.sh $to/upload.sh
}
scp_getPlugin_Backbone(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/$thisServerName.config.yml $to/config.yml
scp $from/upload.sh $to/upload.sh
}
scp_getPlugin_SuperCensor(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to
scp $from/words.yml $to
}
scp_getPlugin_ChatControl(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
}
scp_getPlugin_VanillaPod(){
local name=$1
local from=$syncServerScpPath/plugins/$name
local to=$thisServerPath/plugins/$name
scp $from/config.yml $to
}
