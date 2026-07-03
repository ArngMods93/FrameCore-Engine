package mobile.backend;

import lime.utils.Assets;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import haxe.io.Bytes;

using StringTools;

class StorageUtil
{
    public static var rootPath:String = #if android lime.system.System.documentsDirectory #else "./" #end;

    public static function init():Void
    {
        #if android
        if (!FileSystem.exists(rootPath))
            FileSystem.createDirectory(rootPath);

        checkAndCopyFiles();
        #end
    }

    private static function checkAndCopyFiles():Void
    {
        for (asset in Assets.list())
        {
            if (asset.startsWith("assets/") || asset.startsWith("mods/"))
            {
                var targetPath:String = Path.join([rootPath, asset]);
                var directory:String = Path.directory(targetPath);

                if (!FileSystem.exists(directory))
                    FileSystem.createDirectory(directory);

                var shouldCopy:Bool = false;

                if (!FileSystem.exists(targetPath))
                {
                    shouldCopy = true;
                }
                else
                {
                    var assetBytes:Bytes = Assets.getBytes(asset);
                    if (assetBytes != null)
                    {
                        var existingBytes:Bytes = File.getBytes(targetPath);
                        if (existingBytes == null || assetBytes.length != existingBytes.length)
                            shouldCopy = true;
                    }
                }

                if (shouldCopy)
                {
                    var bytes:Bytes = Assets.getBytes(asset);
                    if (bytes != null)
                        File.saveBytes(targetPath, bytes);
                }
            }
        }
    }
}
