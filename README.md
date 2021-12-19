Add audio waveforms with ability to customize them and show active track for audio.

# Features

You can use the following available waveform types.
/// Images of waveforms inactive

Need some gradient for your waveform? Say no more! You get it along with other customization options.

Want an active track for your audio out of the box?
You get that too!
//gifs with active waveforms




# Getting started

The package gives you the ability to add waveforms and customize them.
It's mostly like a UI library for waveforms with an additional ability to show active track for playing audio.

So it relies on you to provide the necessary audio data which it needs to draw the waveform.
The data we need is basically a list of points that represents that audio on a graph.

You can use this [waveform generator](https://github.com/bbc/audiowaveform) to get the [json audio data](https://gist.github.com/rutvik110/946ee0f3036a18da1297e57c547ae241) from an audio file. The generated data needs to be processed following some rules which are necessary to get the waveforms drawn properly. To process the data use [this parser]().

Once you have the processed data points list then you can just pass it down to any of the waveforms available and get started using them.




# Usage

Usage of all waveforms available is the same with only exception of having more/less customization options for different waveforms.


```dart
 PolygonWaveform( 
   maxDuration: maxDuration,
   elapsedDuration: elapsedDuration,
   samples: samples,
   height: height,
   width: width, 
 )
 ```

```dart
 RectangleWaveform(
   maxDuration: maxDuration,
   elapsedDuration: elapsedDuration,
   samples: samples,
   height: height,
   width: width,
 )
```

```dart
 SquigglyWaveform(
   maxDuration: maxDuration,
   elapsedDuration: elapsedDuration,
   samples: samples,
   height: height,
   width: width,
 )
```

> Find detailed example in `example section` with some `sample data` ready to use.

## Properties

maxDuration:

Maximum duration of the audio.

elapsedDuration:

Elapsed Duration of the audio.

samples:

List of the audio data samples.
> Check the **Getting Started** section on how to generate this.

height :

Waveforms height.

width :

Waveform width.


## Customization Options

inactiveColor :

Color of the inactive waveform.

activeColor :

Color of the active waveform.

inactiveGradient :

Gradient of the inactive waveform.

activeGradient :

Gradient of the active waveform.

absolute :

Waveform drawn is one sided either above x-axis or below it depending on what `invert` is set to.

Defaults to `false`.

invert :

Flips/inverts the waveform upside down.

Defaults to `false`.

borderWidth : 

Width of the border around waveform. 

Available only for `RectangleWaveform`.

strokeWidth :

Waveform stroke width.

Available only for `SquigglyWaveform`.

inactiveBorderColor:

Border color for inactive waveform.

Available only for `RectangleWaveform`.

activeBorderColor:

Border color for active waveform.

Available only for `RectangleWaveform`.

showActiveWaveform:

Whether to show active waveform or not.

Defaults to `true`.


**More customization options coming soon!**





# Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
