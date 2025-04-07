import connexion
from pathlib import Path
import six
import sys
from flask import send_file, request as flask_request

from swagger_server import util
sys.path.append("/home/cc/team20/proj/git/table-transformer/src")
from model_service import get_args, TableExtractModel


def create_model():
    dir_name_postfix = "service"
    input_args = [
        '--use_ocr',
        '--mode', 'extract',
        '--image_dir',             f'/home/cc/team20/data/tiny_fintabnet_database/page_images/{dir_name_postfix}',
        '--page_words_dir',        f'/home/cc/team20/data/tiny_fintabnet_database/FinTabNet.c_PDF_Annotations_JSON',
        '--table_words_dir',       f'/home/cc/team20/data/tiny_fintabnet_database/FinTabNet.c_Image_Table_Words_JSON',
        '--ocr_words_dir',         f'/home/cc/team20/data/tiny_fintabnet_database/ocr_results/{dir_name_postfix}',
        '--out_dir',               f'/home/cc/team20/data/tiny_fintabnet_database/inference_output/{dir_name_postfix}',
        '--structure_config_path', f'/home/cc/team20/proj/git/table-transformer/src/structure_config.json',
        '--structure_model_path',  f'/home/cc/team20/models/TATR-v1.1-Fin-msft.pth',
        '--detection_config_path', f'/home/cc/team20/proj/git/table-transformer/src/detection_config.json',
        '--detection_model_path',  f'/home/cc/team20/models/pubtables1m_detection_detr_r18.pth',
        '--html',
        '--csv',
        '--objects',
        '--crops',
        '--visualize',
        '--tesseract_cmd', '/home/cc/team20/proj/tesseract-ocr_install/bin/tesseract'
    ]

    args = get_args(input_args)
    model = TableExtractModel(args)

    return model


model = create_model()


def table_extract_post(file):
    args = model.args

    file_name = file.filename
    # file_data = file.read()
    image_file_path = Path(args.image_dir) / file.filename
    image_file_path.parent.mkdir(parents=True, exist_ok=True)
    file.save(str(image_file_path))

    Path(args.out_dir).mkdir(parents=True, exist_ok=True)

    query_params = connexion.request.query_params

    for query, value in query_params.items():
        print(query, value)

    mode = query_params["mode"]
    args.mode = mode.lower()

    ocr_option = query_params["OCR"]
    args.use_ocr = ocr_option.lower() == "Tesseract OCR".lower()

    print(f"processing: {image_file_path}")
    output_file_path = model.process(str(image_file_path))

    print(f"output_file_path: {output_file_path}")

    return send_file(output_file_path,
                     as_attachment=True,
                     download_name=output_file_path.name)
