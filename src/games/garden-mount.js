import React from 'react';
import { createRoot } from 'react-dom/client';
import HerbGardenGame from './garden-continuation.tsx';

let root;
export function mountGarden(container, member) {
  root?.unmount();
  root = createRoot(container);
  root.render(React.createElement(HerbGardenGame, { member }));
}
export function unmountGarden() {
  root?.unmount();
  root = undefined;
}
