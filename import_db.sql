CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  title VARCHAR(255),
  body TEXT,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

 CREATE TABLE question_likes (
   id INTEGER PRIMARY KEY,
   question_id INTEGER,
   user_id INTEGER,
   FOREIGN KEY (question_id) REFERENCES questions(id),
   FOREIGN KEY (user_id) REFERENCES users(id)
 );


 INSERT INTO
  users (fname, lname)
 VALUES
  ('Ben', 'Sullivan'),
  ('Pat', 'Brent');

INSERT INTO
  questions (author_id, title, body)
VALUES
  ((SELECT id FROM users WHERE fname = 'Pat'),
  'first question', 'what question should we insert?'),

  ((SELECT id FROM users WHERE fname = 'Ben'),
  'second question', 'what day is it today?'),

  ((SELECT id FROM users WHERE fname = 'Pat'),
  'third question', 'when do we get pictures of Sennacy?');

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'first question'),
  (SELECT id FROM users WHERE fname = 'Pat')),

  ((SELECT id FROM questions WHERE title = 'second question'),
  (SELECT id FROM users WHERE fname = 'Ben')),

  ((SELECT id FROM questions WHERE title = 'third question'),
  (SELECT id FROM users WHERE fname = 'Pat')),

  ((SELECT id FROM questions WHERE title = 'third question'),
  (SELECT id FROM users WHERE fname = 'Ben'));

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (
    (SELECT id FROM questions WHERE title = 'first question'),
    NULL,
    (SELECT id FROM users WHERE fname = 'Ben'),
    'Lets ask a TA.'
  ),

  (
    (SELECT id FROM questions WHERE title = 'first question'),
    (SELECT id FROM replies WHERE body = 'Lets ask a TA.'),
    (SELECT id FROM users WHERE fname = 'Pat'),
    'Good idea'
  ),

  (
    (SELECT id FROM questions WHERE title = 'second question'),
    NULL,
    (SELECT id FROM users WHERE fname = 'Pat'),
    'I think its Tuesday.'
  );

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'first question'),
   (SELECT id FROM users WHERE fname = 'Ben')),

  ((SELECT id FROM questions WHERE title = 'second question'),
   (SELECT id FROM users WHERE fname = 'Pat'));
