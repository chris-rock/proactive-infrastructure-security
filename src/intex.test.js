const request = require("supertest");
const app = require("./index");

describe("Express App", () => {
  let csrfToken;
  let cookies;

  // Helper function to get CSRF token
  const getCsrfToken = async () => {
    const response = await request(app).get("/");
    const cookieHeader = response.headers["set-cookie"];
    cookies = cookieHeader.map((cookie) => cookie.split(";")[0]).join("; ");
    const match = response.text.match(/value="([^"]+)"/);
    return match ? match[1] : null;
  };

  beforeEach(async () => {
    csrfToken = await getCsrfToken();
  });

  test("GET / should return 200", async () => {
    const response = await request(app).get("/");
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain("Fancy Demo App with CSRF Protection");
  });

  test("GET /api/items should return items array", async () => {
    const response = await request(app).get("/api/items");
    expect(response.statusCode).toBe(200);
    expect(Array.isArray(response.body)).toBeTruthy();
  });

  test("POST /api/items should add a new item", async () => {
    const newItem = { name: "Test Item" };
    const response = await request(app)
      .post("/api/items")
      .set("Cookie", cookies)
      .set("CSRF-Token", csrfToken)
      .send(newItem);

    expect(response.statusCode).toBe(201);
    expect(response.body.name).toBe(newItem.name);

    const getResponse = await request(app).get("/api/items");
    expect(
      getResponse.body.some((item) => item.name === newItem.name),
    ).toBeTruthy();
  });
});
