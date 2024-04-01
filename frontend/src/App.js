import React, { useEffect, useState } from 'react';
import './App.css'; // Ensure this contains some basic layout styles if needed
import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  const [streamData, setStreamData] = useState({ stream_1: '', stream_2: '', stream_3: '', stream_4: '' });

  useEffect(() => {
    const socket = new WebSocket('ws://127.0.0.1:5678');

    socket.onmessage = (event) => {
      const [stream_1, stream_2, stream_3, stream_4] = event.data.split(';');
      setStreamData({
        stream_1: stream_1 ? `data:image/jpeg;base64,${stream_1}` : '/images/link.png',
        stream_2: stream_2 ? `data:image/jpeg;base64,${stream_2}` : '/images/link.png',
        stream_3: stream_3 ? `data:image/jpeg;base64,${stream_3}` : '/images/link.png',
        stream_4: stream_4 ? `data:image/jpeg;base64,${stream_4}` : '/images/link.png',
      });
    };

    return () => socket.close();
  }, []);

  return (
    <div className="container mt-5">
      <div className="row">
        {Object.keys(streamData).map((key, index) => (
          <div className="col-12 col-md-6 mb-4" key={index}>
            <div className="card">
              <img src={streamData[key]} className="card-img-top" alt={`Stream ${index + 1}`}
                   onError={(e) => { e.target.onerror = null; e.target.src="placeholder-image.jpg"; }}/>
              <div className="card-body">
                <p className="card-text">{`Stream ${index + 1}`}</p>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
