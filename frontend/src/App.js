import React, { useEffect, useState } from 'react';

function App() {
  const [ipsData, setIpsData] = useState([]);

  useEffect(() => {
    // Fetch data from the /ipsAlt endpoint on your Go backend
    fetch('/ipsAlt')
      .then(response => response.json())
      .then(data => {
        setIpsData(data);
      })
      .catch(error => console.error('Error fetching data:', error));
  }, []);

  return (
    <div>
      <h1>IPS Alt Records</h1>
      {ipsData.length === 0 ? (
        <p>Loading...</p>
      ) : (
        <ul>
          {ipsData.map(record => (
            <li key={record.id}>
              {record.patientName} ({record.patientGiven})
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

export default App;
