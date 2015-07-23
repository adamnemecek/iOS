//
//  MIDIFileManager.swift
//  FileManagement
//
//  Created by Massil on 25/03/2015.
//  Copyright (c) 2015 __ORPHEE__. All rights reserved.
//

import UIKit

/// Class MIDIFileManager implements pFormattedFileManager
///
/// A file manager dedicated to MIDI files.
public class MIDIFileManager: pFormattedFileManager {

    /// The formatted file type's standard extension.
    public static var ext: String {
        return "mid";
    };

    /// The formatted file type's standard storing directory.
    public static var store: String {
        return "/Users/Massil/Desktop";
    }

    /// The object used to write to the managed file.
    public lazy var writer: pOutputManager = MIDIWriter(path: self.path);

    /// The object used to read from the managed file.
    public lazy var reader: pInputManager = MIDIReader(path: self.path);

    /// The name to the managed file.
    public var name: String;

    public var path: String {
        get {
            return (MIDIFileManager.store + "/" + self.name + "." + MIDIFileManager.ext)
        }
    }

    public required init(name: String) {

        self.name = name;
    }

    public func createFile(name: String?, content: [String : AnyObject]?) -> Bool {

        if (name != nil) {
            self.name = name!;
        }

        NSFileManager.defaultManager().createFileAtPath(self.path, contents: nil, attributes: nil);

        let midiFile = MIDIFileCreator();
        if let tracks: AnyObject = content?["TRACKS"] {
            let trackList = tracks as! [Int : [[Int]]];
            for (_, track) in trackList {
                midiFile.addTrack(track);
            }
        }
        return writer.write(midiFile.dataForFile());
    }

    public func readFile(name: String?) -> [String : AnyObject]? {

        if (name != nil) {
            self.name = name!;
        }

        let parser = MIDIDataParser(data: reader.readAllData());
        return ["TRACKS" : parser.parseTracks()];
    }
    
    public func deleteFile() {
        
    }
}
