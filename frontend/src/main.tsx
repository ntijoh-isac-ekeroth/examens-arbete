// import React from "react";
// import ReactDOM from "react-dom/client";
// import App from "./components/DensityPlot";
// import "./index.css";
// import Graph from "./components/DensityPlot";
import data from "./data";
import App from "./components/DensityPlot";
import * as React from "react";
import * as ReactDOM from "react-dom";

// ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
//   <React.StrictMode>
//     <App width={100} height={100} data={data} />
//   </React.StrictMode>
// );
ReactDOM.render(
  <App width={window.innerWidth} height={window.innerHeight} data={data} />,
  document.getElementById("app")
);
