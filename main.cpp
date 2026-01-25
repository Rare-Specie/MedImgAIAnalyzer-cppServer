// main.cpp - 最小 Crow 服务示例

#include <crow.h>//如果遇到神秘问题可以尝试不要引入全量crow头文件而是只引入需要的

int main()
{
    crow::SimpleApp app;

    CROW_ROUTE(app, "/api/health")([](){
        crow::json::wvalue res;
        res["status"] = "ok";
        return crow::response{res};
    });

    // 监听 18080 端口
    app.port(18080).multithreaded().run();
    return 0;
}
