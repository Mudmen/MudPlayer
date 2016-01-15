//
//  AVPlayerItem+extension.swift
//  MudPlayerExample
//
//  Created by TimTiger on 16/1/15.
//  Copyright © 2016年 Mudmen. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayerItem {
    
    var playProgress: Double {
        return self.currentSeconds/self.durationSeconds
    }
    
    var loadedProgress: Double {
        return self.loadedDurationSeconds/self.durationSeconds
    }
    
    var durationSeconds: Double {
        let seconds =  CMTimeGetSeconds(self.duration)
        if seconds.isNormal {
            return seconds
        }
        return 0
    }
    
    var currentSeconds: Double {
        let seconds =  CMTimeGetSeconds(self.currentTime())
        if seconds.isNormal {
            return seconds
        }
        return 0
    }
    
    var loadedDurationSeconds: Double {
        let loadedTimeRanges = self.loadedTimeRanges
        if  loadedTimeRanges.count < 1 {
            return 0
        }
        let timeRange: CMTimeRange = loadedTimeRanges.first!.CMTimeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSeconds = CMTimeGetSeconds(timeRange.duration)
        return startSeconds + durationSeconds
    }
}