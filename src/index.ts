import { NativeModules, NativeEventEmitter } from 'react-native';

const { ShoutMeter } = NativeModules;
const emitter = new NativeEventEmitter(ShoutMeter);

let listener: any = null;

export const startShout = () => {
  return ShoutMeter.start();
};

export const stopShout = () => {
  if (listener) {
    listener.remove();
    listener = null;
  }
  ShoutMeter.stop();
};

export const onShoutLevel = (callback: (level: number) => void) => {
  listener = emitter.addListener('onShoutLevel', (data) => {
    callback(data.level);
  });
};
