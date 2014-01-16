musician(tom_scholz, keyboard).
musician(neal_schon, guitar).
musician(paul_mccartney, guitar).
musician(ed_king, bass).

genre(rock, tom_scholz).
genre(progressive_rock, tom_scholz).
genre(pop_rock, tom_scholz).
genre(rock, neal_schon).
genre(instrumental_rock, neal_schon).
genre(hard_rock, neal_schon).
genre(progressive_rock, neal_schon).
genre(rock, ed_king).
genre(smooth_jazz, ed_king).
genre(psychedelic_rock, ed_king).
genre(classic_rock, paul_mccartney).
genre(electronica, paul_mccartney).

plays(Artist, Instrument) :- musician(Artist, Instrument).
genres(Genre, Artist) :- genre(Genre, Artist).

