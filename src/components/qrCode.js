import QRCode from "react-qr-code";

const QRURL = "https://academy-workshops.launchdarklydemos.com";

const qrCodeHome = () => {  
  return (
    <div className="mx-auto shadow-2xl">
      <div className="qr-wrapper">
        <QRCode size="150" value={QRURL} />
        <div className="text-xl font-sohne pt-4">
        <p>SCAN ME to join in</p>
        </div>
      </div>
    </div>
  )     
};

export default qrCodeHome;
