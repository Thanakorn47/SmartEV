const express = require('express');
const mongoose = require('mongoose');
const app = express();
const port = 3000;

app.use(express.json());

// MongoDB connection
mongoose.connect('mongodb+srv://admin:1234@cluster0.9hn1d.mongodb.net/', { 
  useNewUrlParser: true, 
  useUnifiedTopology: true 
})
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log('MongoDB connection error:', err));

const userSchema = new mongoose.Schema({
    name: String,
    email: String,
  });
  
  const User = mongoose.model('User', userSchema);

// Example route to get user data
app.get('/api/user', async (req, res) => {
  try {
    const user = await User.findOne(); // Fetch a user from the database
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching user', error });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
