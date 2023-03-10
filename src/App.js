import React, { useEffect } from "react";
import QRCode from "./components/qrCode";
import "./App.css";
import { useFlags } from "launchdarkly-react-client-sdk";
import Login from "./components/login";
import ld from "./academy.png";
import Connection from "./components/connection";

function App() {
  const { login, bgstyle, qrcode, workshopOn } = useFlags();

  const [bg, setbg] = React.useState();

  useEffect(() => {
    console.log("update to bg detected");
    setbg(bgstyle);
  }, [bgstyle]);

  console.log(bgstyle);

  return (
    <div className="App h-screen bg- grid xl:grid-cols-4 grid-cols-1 grid-rows-4 xl:grid-rows-3 bg-cover bg-no-repeat"
      style={{ backgroundImage: `url('./ld-bg.png')` }}>
      <div className="body grid xl:col-span-1 xl:col-start-1 xl:row-start-1 w-full xl:w-4/5 bg-black-4 place-items-center">
        <img src={ld} className="mx-auto max-h-30 px-8" alt="logo" />
      </div>
      {login ? (
        <header className="App-header mx-auto bg-ldgray shadow-2xl w-full xl:w-full grid col-span-1 row-start-2 xl:col-start-2 xl:col-span-2">
          <Login />
        </header>
      ) : (
        <header className="App-header grid row-start-2 xl:row-start-2 xl:col-start-2 xl:col-span-2">
          <div className="body px-8 py-4 mb-5 w-4/5">
            <div className="text-2xl md:text-5xl xl:text-7xl font-audimat text-transparent bg-clip-text bg-gradient-to-br from-ldgdcol1 to-ldgdcol2">
              It's time for liftoff 
            </div>
            <div className="text-2xl md:text-5xl xl:text-3xl">
              <p>
                <span className="font-audimat text-transparent bg-clip-text bg-gradient-to-br from-ldgdcol1 to-ldgdcol2">
                Get up to speed with everything you need to control code with LaunchDarkly.
                </span>
              </p>
            </div>
          </div>
        </header>
      )}
      {qrcode ? (
        <div className="body grid mx-auto row-start-4 xl:col-span-1 xl:col-start-4 xl:row-start-1 bg-black-4 place-content-center">
          <QRCode />
        </div>
      ) : null}
      {workshopOn ?
        <div className="mx-auto xl:col-span-2 row-start-3 w-full xl:w-full xl:col-start-2 bg-black-4">
          <Connection />
        </div>
      :null}
    </div>
  );
}

export default App;
