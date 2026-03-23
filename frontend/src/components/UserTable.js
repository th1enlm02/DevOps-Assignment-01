import { useState } from "react";

function UserTable({ users, onUpdate }) {
  const [editedUsers, setEditedUsers] = useState({});

  const handleChange = (id, field, value) => {
    setEditedUsers((prev) => ({
      ...prev,
      [id]: {
        ...prev[id],
        id,
        [field]: value
      }
    }));
  };

  const handleSubmit = () => {
    const data = Object.values(editedUsers);
    if (data.length === 0) return;

    onUpdate(data);
    setEditedUsers({});
  };

  return (
    <div>
      <table border="1" cellPadding="5">
        <thead>
          <tr>
            <th>Username</th>
            <th>Email</th>
            <th>Birthdate</th>
          </tr>
        </thead>

        <tbody>
          {users.map((user) => (
            <tr key={user.userId}>
              <td>
                <input
                  defaultValue={user.username}
                  onChange={(e) =>
                    handleChange(user.userId, "username", e.target.value)
                  }
                />
              </td>

              <td>
                <input
                  defaultValue={user.email}
                  onChange={(e) =>
                    handleChange(user.userId, "email", e.target.value)
                  }
                />
              </td>

              <td>
                <input
                  type="date"
                  defaultValue={user.birthdate?.slice(0, 10)}
                  onChange={(e) =>
                    handleChange(user.userId, "birthdate", e.target.value)
                  }
                />
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      <button onClick={handleSubmit} style={{ marginTop: 10 }}>
        Click to update users
      </button>
    </div>
  );
}

export default UserTable;
