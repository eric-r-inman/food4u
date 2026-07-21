//! The typed model survives a round trip through JSON, the request/response
//! wire format the API still uses between the frontend and the server.
#![allow(clippy::expect_used, clippy::unwrap_used, clippy::panic)]

use food4u_server::model::{
  Card, Food, Group, Item, Model, PlannerEntry, Recipe, Tier,
};

#[test]
fn the_typed_model_round_trips_through_json() {
  // A small model touching every field, including a quote in a name and a
  // newline in the instructions, so the JSON escaping is exercised too.
  let model = Model {
    tiers: vec![Tier {
      id: "t1".into(),
      no: "01".into(),
      name: "Foundation".into(),
      freq: "daily".into(),
      width: "wide".into(),
      rail: "#111".into(),
      tint: "#eee".into(),
      line: "#ccc".into(),
      groups: vec![Group {
        id: "g1".into(),
        label: "Greens".into(),
        foods: vec![Food {
          id: "f1".into(),
          name: "Kale".into(),
          prep: "F".into(),
          hero: true,
          na: true,
          recipe_id: "r1".into(),
        }],
      }],
    }],
    staples: vec![Card {
      id: "c1".into(),
      name: "Pantry".into(),
      meta: "dry goods".into(),
      rail: "#222".into(),
      line: "#333".into(),
      note: "".into(),
      zone: "kitchen".into(),
      items: vec![Item {
        id: "i1".into(),
        name: "Rice".into(),
        na: true,
        count: 1,
      }],
    }],
    recipes: vec![Recipe {
      id: "r1".into(),
      name: "Herb's Salad".into(),
      category: "Salads".into(),
      ingredients: vec![Item {
        id: "in1".into(),
        name: "Kale".into(),
        na: false,
        count: 1,
      }],
      instructions: "Toss it.\nServe cold.".into(),
      bookmarked: true,
      tags: vec!["quick".into(), "vegetarian".into()],
    }],
    planner: vec![PlannerEntry {
      id: "p1".into(),
      day: 0,
      meal: "Breakfast".into(),
      recipe_id: "r1".into(),
    }],
    planner_days: 10,
    column_order: vec!["planner".into(), "pyramid".into()],
  };

  let reserialized = serde_json::to_string(&model).unwrap();
  let again: Model = serde_json::from_str(&reserialized).unwrap();

  assert_eq!(
    model, again,
    "re-parsing the serialized model should reproduce it exactly"
  );
}
