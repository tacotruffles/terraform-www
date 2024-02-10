import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <div>
        <small>API URL Ingested from Layer 3: <b>{process.env.REACT_APP_API_URL}</b>.</small>
        </div>
      </header>
    </div>
  );
}

export default App;
