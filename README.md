# react-native-shout-meter

A React Native module that measures microphone input volume (Shout Power) in real time.  
Currently iOS only.

## Installation

Clone this repo into your project or install it via GitHub:

```
npm install github:a16gems/react-native-shout-meter
```

Then link the native code (if not autolinked):

```
npx pod-install
```

## Usage

```ts
import { startShout, stopShout, onShoutLevel } from 'react-native-shout-meter';

await startShout();

onShoutLevel((level) => {
  console.log('Shout power:', level); // level from 0.0 to 1.0
});

// When done
stopShout();
```

## iOS Setup

Make sure to add this key to your `Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app uses the microphone to detect shout intensity.</string>
```

## License

MIT
