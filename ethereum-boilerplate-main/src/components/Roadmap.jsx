import { useMoralis } from "react-moralis";
import React from "react";

function Roadmap() {
  const { authenticate, isAuthenticated } = useMoralis();

  if (!isAuthenticated) {
    return (
      <div>
        <button onClick={() => authenticate()}>Authenticate</button>
      </div>
    );
  }

  return (
    <dl>
      Road Map
      <dt>Make an NFT Game </dt>
      <dd>
        A coordination game escaltion game that incentivies growth dynamics{" "}
      </dd>
      <dt>ELI5</dt>
      <dd>Player commit their valueless NFT into buckets and play a game</dd>
    </dl>
  );
}

export default Roadmap;
