import unittest
import time
from ants import Place, Insect

class TestAnts(unittest.TestCase):
    def setUp(self):
        self.place1 = Place("place1")
        self.place2 = Place("place2", self.place1)
        self.insect = Insect(10)

    def test_place_init(self):
        self.assertEqual(self.place1.name, "place1")
        self.assertIsNone(self.place1.exit)
        self.assertEqual(self.place1.bees, [])
        self.assertIsNone(self.place1.ant)
        self.assertEqual(self.place1.entrance, self.place2)

        self.assertEqual(self.place2.name, "place2")
        self.assertEqual(self.place2.exit, self.place1)
        self.assertEqual(self.place2.bees, [])
        self.assertIsNone(self.place2.ant)
        self.assertIsNone(self.place2.entrance)

    def test_place_add_remove_insect(self):
        self.place1.add_insect(self.insect)
        self.assertEqual(self.insect.place, self.place1)

        self.place1.remove_insect(self.insect)
        self.assertIsNone(self.insect.place)

    def test_insect_init(self):
        self.assertEqual(self.insect.health, 10)
        self.assertIsNone(self.insect.place)

    def test_insect_reduce_health(self):
        self.insect.reduce_health(2)
        self.assertEqual(self.insect.health, 8)

        self.insect.reduce_health(8)
        self.assertEqual(self.insect.health, 0)
        self.assertIsNone(self.insect.place)

    def test_insect_add_remove_from(self):
        self.insect.add_to(self.place1)
        self.assertEqual(self.insect.place, self.place1)

        self.insect.remove_from(self.place1)
        self.assertIsNone(self.insect.place)

    def test_place_init_time(self):
        start_time = time.time()
        Place("place3", self.place2)
        end_time = time.time()
        print(f"Initialization of Place took {end_time - start_time} seconds")

    def test_insect_init_time(self):
        start_time = time.time()
        Insect(10, self.place1)
        end_time = time.time()
        print(f"Initialization of Insect took {end_time - start_time} seconds")

    def test_insect_reduce_health_time(self):
        start_time = time.time()
        self.insect.reduce_health(2)
        end_time = time.time()
        print(f"Reducing health of Insect took {end_time - start_time} seconds")

if __name__ == '__main__':
    unittest.main()