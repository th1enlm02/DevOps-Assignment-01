import { useState } from "react";
import { searchUsers, updateUsers } from "./services/api";
import UserTable from "./components/UserTable";

function App() {
  const [query, setQuery] = useState("");
  const [users, setUsers] = useState([]);

  const handleSearch = async () => {
    const res = await searchUsers(query);
    setUsers(res.data);
  };

  const handleUpdate = async (updatedUsers) => {
    await updateUsers(updatedUsers);
    handleSearch(); // refresh
  };

  return (
    <div style={{ padding: 20 }}>
      <h2>User Search</h2>

      <input
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Search username or email"
        style={{ marginBottom: 10, marginRight: 10 }}
      />

      <button onClick={handleSearch}>Search</button>

      <UserTable users={users} onUpdate={handleUpdate} />
    </div>
  );
}

export default App;