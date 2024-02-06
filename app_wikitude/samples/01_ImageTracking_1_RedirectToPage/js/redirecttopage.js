var World = {
    
    metadata: null,

    loadMetadata: function (callback) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'assets/metadata.json', true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                World.metadata = JSON.parse(xhr.responseText);
                callback();
            }
        };
        xhr.send();
    },

    init: function initFn() {
        this.loadMetadata(function () {
            this.createOverlays();
        }.bind(this));
    },

    createOverlays: function createOverlaysFn() {

        this.targetCollectionResource = new AR.TargetCollectionResource("assets/tracker.zip", {
            onError: World.onError
        });

        this.tracker = new AR.ImageTracker(this.targetCollectionResource, {
            onError: World.onError
        });

        this.WorkoutExercises = new AR.ImageTrackable(this.tracker, "*", {
            onImageRecognized: function(target) {
                var targetInfo = World.findTargetInfo(target.name);
                if (targetInfo.custom) {
                    // Use targetInfo for your augmentation
                    console.log("Target Info: " + JSON.stringify(targetInfo.custom));

                    // Send the JSON object with the data from targetInfo
                    AR.platform.sendJSONObject(targetInfo.custom);
                } else {
                    console.log("Target not found in metadata: " + target.name);
                }
            },
            onError: World.onError
        });
    },

    findTargetInfo: function findTargetInfoFn(targetName) {
        if (World.metadata && World.metadata.targets) {
            for (var i = 0; i < World.metadata.targets.length; i++) {
                if (World.metadata.targets[i].name === targetName) {
                    return World.metadata.targets[i];
                }
            }
        }
        return null;
    },

    onError: function onErrorFn(error) {
        alert(error);
    },
};

World.init();