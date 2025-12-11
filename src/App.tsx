import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { InterviewPage } from './pages/InterviewPage';
import { TutorialPage } from './pages/TutorialPage';
import './App.css';

function App() {
  return (
    <BrowserRouter>
      <div className="app">
        <Routes>
          <Route path="/" element={<InterviewPage />} />
          <Route path="/tutorial" element={<TutorialPage />} />
        </Routes>
        <div className="attribution">
          made by Sina Foudehi aka BrieOfStability
        </div>
      </div>
    </BrowserRouter>
  );
}

export default App;







