import React, { useState } from "react";
import { useFlags } from "launchdarkly-react-client-sdk";


export default function Connection() {
  const { dbinfo } = useFlags();
  const [creds, setCreds] = useState('')

  async function queryCreds() {
    const response = await fetch( window.location.protocol +
      "//" +
      window.location.host +
      "/getcreds")
    // const response = await fetch("http://127.0.0.1:5000/getcreds")
    if (response.status === 200) {
      const data = await response.json()
      setCreds(data)
      console.log(creds)
      return data
    } else {
    const data = await response.text()
    console.log("hmmm")
    console.log(data)
    return data
  }
}

async function clearCreds() {
  setCreds(null)
  console.log("creds cleared")
}

  return (
    <div className="flex mx-auto w-full h-full space-x-4">
      <div
        className="grid grid-cols-1 xl:grid-cols-2 mx-auto justify-center items-center bg-ldinput shadow-2xl py-4 px-4 xl:py-8 xl:px-8 w-full"
      >
        <div>
          <h1 className="font-sohne text-ldgraytext text-base px-2 lg:text-3xl pb-3">
            Get Workshop Credentials 
          </h1>
          <div>
          <button
              className="bg-lddblue text-white font-sohne text-base xl:text-xl uppercase px-3 py-1 xl:px-6 xl:py-3 ease-linear transition-all duration-150"
              type="button"
              onClick={() => queryCreds()}
            >
            Get Credentials
          </button>
          </div>
          <div className="pt-3">
          <button
              className="bg-ldred text-white font-sohne text-base xl:text-xl uppercase px-3 py-1 xl:px-6 xl:py-3 ease-linear transition-all duration-150"
              type="button"
              onClick={() => clearCreds()}
            >
            Clear Credentials
          </button>
          </div>
        </div>
        <div className="grid py-4">
          { creds ? (
            <div className="font-sohne text-ldgraytext text-base px-2 lg:text-xl pb-3 text-left">
          <p className="py-1">Sign in URL: <a className="text-blue-600 hover:text-blue-800" href={creds.url}>Click Here</a></p>
          {/* <p className="py-1">Client Key: {creds.client_key}</p>
          <p className="py-1">Client Key: {creds.server_key}</p> */}
            </div>
):null
          }
          </div>
      </div>
    </div>
  );
}
