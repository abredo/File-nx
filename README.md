# File-nx
swift command line for creating @2x @3x .png used in iOS Apps.
![image](https://github.com/abredo/File-nx/blob/master/tips.gif) 

![image](https://github.com/abredo/File-nx/blob/master/File%40nx_gold.gif) 
```swift
//
//  main.swift
//  File@nx
//
//  Created by juliano on 3/29/16.
//  Copyright © 2016 juliano. All rights reserved.
//

import Foundation

func resizeFile( originFile : String,fileSuffix : String, width : Float,height : Float)  {
    let range = originFile.rangeOfString(".png")
    guard range != nil && (range?.startIndex != range?.endIndex) else
    {
        return
    }
    var nFileName = String.init(originFile)
    nFileName.insertContentsOf(fileSuffix.characters, at: (range?.startIndex)!)
    print("fileName****:%@",nFileName)
    
    
    let cpFileCmd = "cp \(originFile) \(nFileName)"
    print(cpFileCmd)
    system(cpFileCmd)
   /* -z pixelsH pixelsW
    --resampleHeightWidth pixelsH pixelsW
    Resample image at specified size. Image apsect ratio may be
    altered.*/
    let sizp = "sips -z \(height) \(width) \(nFileName)"
//    let sizp = "sips -Z \(width) \(fileName2)"
    system(sizp)
    print(sizp)
    
}

func getImageSize(imagePath : String) -> CGSize {
    print(imagePath)
   return PngHelper.getPNGSize(imagePath)
}


let arguments = Process.arguments
if arguments.count > 1
{
    print("hello")
    let  dirPath = arguments[1]
    let fmg = NSFileManager.defaultManager()
    var childArray = [String]();
    do
    {
        childArray = try fmg.contentsOfDirectoryAtPath(dirPath)
    }catch
    {
        print("Error occurs when listing files in dir :\(dirPath)")
        exit(0)
    }
    
    
    if(childArray.count > 0)
    {
        print("Number of files at \(dirPath):\(childArray.count)")
        let dfmt = NSDateFormatter.init()
        dfmt.dateFormat = "yyyyMMdd_HH:mm:ss"
        let now = dfmt.stringFromDate(NSDate())
        let destFilePath = dirPath + "/" + "\(now)_Files"
        system("mkdir \(destFilePath)")
        
        for i in 0..<childArray.count
        {
            let imageName = childArray[i]
            
            if imageName.containsString("@2x") || imageName.containsString("@3x") || (!imageName.hasSuffix(".png"))
            {
                //if the file is not a png , or it's already an @2x/@3x png file,should do nothing
            }
            else
            {
                
                let originFilePath = dirPath + "/" + imageName
                let imageSize = getImageSize(originFilePath)
                if !(imageSize.width <= 0 || imageSize.height <= 0)
                {
                    let destResizeFilePath = destFilePath + "/" + imageName
                    //cp file to destination path
                    system("cp \(originFilePath) \(destResizeFilePath)")
                    
                    //@2x.png
                    resizeFile(destResizeFilePath, fileSuffix: "@2x", width:Float(imageSize.width) * 2.0 / 3.0, height:Float( imageSize.height) * 2.0 / 3.0)
                    
                    //@3x.png
                    resizeFile(destResizeFilePath, fileSuffix: "@3x", width:Float( imageSize.width), height:Float( imageSize.height))
                    //.png
                   resizeFile(destResizeFilePath, fileSuffix: "", width:Float( imageSize.width)  / 3.0, height:Float( imageSize.height)  / 3.0)
                }
               
            }
            
        }
        
    }else
    {
        print("Error:Catches no files at \(dirPath)!pls check it.")
    }
}









