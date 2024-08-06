import modal
from fastapi import FastAPI, Request, Response, status

from eval import shared
from eval.operation import evaluate

web_app = FastAPI()


@web_app.post("/eval/new")
async def eval_new(request: Request):
    data = await request.json()
    print(data)
    call = evaluate.spawn(data)
    print(call)
    return {"id": call.object_id}


@web_app.get("/eval/result/{id}")
async def eval_result(id: str):
    from modal.functions import FunctionCall

    function_call = FunctionCall.from_id(id)

    try:
        result = function_call.get(timeout=0)
    except TimeoutError:
        return Response(status_code=status.HTTP_202_ACCEPTED)
    return result


@web_app.get("/health")
async def health():
    return Response(status_code=status.HTTP_200_OK)


@shared.app.function(image=shared.image)
@modal.asgi_app()
def fastapi_app():
    return web_app
